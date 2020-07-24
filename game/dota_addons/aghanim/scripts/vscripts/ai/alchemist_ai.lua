--[[ Alchemist AI ]]

require( "ai/ai_core" )

function Spawn( entityKeyValues )
	local hCurrentEncounter = GameRules.Aghanim:GetCurrentRoom():GetEncounter()
	if hCurrentEncounter.activeTargets == nil then
		hCurrentEncounter.activeTargets = {}
	end

	thisEntity:AddNewModifier( thisEntity, nil, "modifier_attack_speed_unslowable", { attack_speed_reduction_pct = 20 } )
	thisEntity:AddNewModifier( thisEntity, nil, "modifier_move_speed_unslowable", { move_speed_reduction_pct = 20 } )

	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
    behaviorSystem = AICore:CreateBehaviorSystem( thisEntity, { BehaviorNone, BehaviorConcoction, BehaviorAcidSpray } ) --, BehaviorRunAway } )
    thisEntity.nextTargetTime = GameRules:GetGameTime()
end

function UpdateOnRemove()
	behaviorSystem:Destroy()
end

function AIThink() -- For some reason AddThinkToEnt doesn't accept member functions
	return behaviorSystem:Think( )
end

--------------------------------------------------------------------------------------------------------

function RemoveAvailableTarget( availableHeroes, nEntIndexToRemove )

	if #availableHeroes == 1 then
		return
	end
	
	for i=1,#availableHeroes do
		if availableHeroes[i]:entindex() == nEntIndexToRemove then
			table.remove( availableHeroes, i )
			break
		end
	end

end

--------------------------------------------------------------------------------------------------------

function SelectNewTarget( )

	local hCurrentEncounter = GameRules.Aghanim:GetCurrentRoom():GetEncounter()

	-- Mark current target as not active any more
	-- Important to do prior to the code that grab a target which is not already being chased
	local nEntIndex = -1
	if thisEntity.hTarget ~= nil then
		nEntIndex = thisEntity.hTarget:entindex()
		hCurrentEncounter.activeTargets[ tostring( nEntIndex ) ] = nil
	end

	local availableHeroes = GetAliveHeroesInRoom()

	-- Remove not visible heroes
	for i=#availableHeroes,1,-1 do
		if not thisEntity:CanEntityBeSeenByMyTeam( availableHeroes[i] ) then
			table.remove( availableHeroes, i )
		end
	end

	-- Prefer to grab a target which is not already being chased by another alchemist 
	for szEntIndex,bIsActive in pairs( hCurrentEncounter.activeTargets ) do
		if bIsActive == true then
			RemoveAvailableTarget( availableHeroes, tonumber( szEntIndex ) )
		end
	end

	-- Prefer to pick a different target from last time
	RemoveAvailableTarget( availableHeroes, nEntIndex )

	-- Select a random target from the available ones
	local hNewTarget = nil
	if #availableHeroes > 0 then
		hNewTarget = availableHeroes[ math.random( 1, #availableHeroes ) ]
	end

	thisEntity.hTarget = hNewTarget
	thisEntity.nextTargetTime = GameRules:GetGameTime() + 8	-- Keep on this target for 8 seconds at least

	if thisEntity.hTarget ~= nil then
		hCurrentEncounter.activeTargets[ tostring( thisEntity.hTarget:entindex() ) ] = true
	end

end

--------------------------------------------------------------------------------------------------------

BehaviorNone = {}

function BehaviorNone:Evaluate()
	return 1 -- must return a value > 0, so we have a default
end

function BehaviorNone:Destroy()

	local hCurrentEncounter = GameRules.Aghanim:GetCurrentRoom():GetEncounter()

	-- Mark current target as not active any more
	if thisEntity.hTarget ~= nil then
		hCurrentEncounter.activeTargets[ tostring( thisEntity.hTarget:entindex() ) ] = nil
		thisEntity.hTarget = nil
	end

end

function BehaviorNone:Begin()
	--print( "BehaviorNone:Begin()" )
	local orders = nil

	-- Acquire a new target if necessary
	if thisEntity.hTarget == nil or ( thisEntity.nextTargetTime <= GameRules:GetGameTime() ) or
		not thisEntity.hTarget:IsAlive() or 			
		( not thisEntity:CanEntityBeSeenByMyTeam( thisEntity.hTarget ) and ( ( thisEntity:GetAbsOrigin() - thisEntity.lastTargetPosition ):Length2D() < 250 ) ) then
			SelectNewTarget()
	end

	if thisEntity.hTarget ~= nil then
		thisEntity.lastTargetPosition = thisEntity.hTarget:GetAbsOrigin()
		orders =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = thisEntity.hTarget:entindex()
		}
	elseif thisEntity.lastTargetPosition ~= nil then
		orders =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			Position = thisEntity.lastTargetPosition
		}
	else
		orders =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_STOP
		}
	end

	return orders
end

BehaviorNone.Continue = BehaviorNone.Begin

--------------------------------------------------------------------------------------------------------

BehaviorConcoction = {}

function BehaviorConcoction:Evaluate()
	--print( "BehaviorConcoction:Evaluate()" )
	local desire = 0
	
	-- let's not choose this twice in a row
	if behaviorSystem.currentBehavior == self then 
		return desire 
	end

	-- Got to have a target
	if thisEntity.hTarget == nil or not thisEntity.hTarget:IsAlive() or not thisEntity:CanEntityBeSeenByMyTeam( thisEntity.hTarget ) then
		return desire
	end

	self.concoctionAbility = thisEntity:FindAbilityByName( "alchemist_unstable_concoction" )
	self.nBrewTime = self.concoctionAbility:GetSpecialValueFor( "brew_time")
	self.nSelfExplodeTime = self.concoctionAbility:GetSpecialValueFor( "brew_explosion")
	
	if self.concoctionAbility and self.concoctionAbility:IsFullyCastable() then

		-- Don't do it if other alchemists are currently conconting
		local friends = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), thisEntity, 5000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
		for i = 1,#friends do
			if friends[i] ~= thisEntity and friends[i].bInConcontion ~= nil and friends[i].bInConcontion == true then
				return desire
			end
		end

		--print( "Concoction:Evaluate: thisEntity.hTarget:entindex() == " .. thisEntity.hTarget:entindex() )
		thisEntity.lastTargetPosition = thisEntity.hTarget:GetAbsOrigin()
		if thisEntity.hTarget:IsStunned() then
			desire = 2
		else
			desire = 4
		end
	end
	
	return desire
end

function BehaviorConcoction:Begin()
	--print( "BehaviorConcoction:Begin()" )

    thisEntity.bInConcontion = true

	if self.startConcoctionTime ~= nil then
		return nil
	end

	self.shivasAbility = nil
	self.phaseAbility = nil
	for i = 0, DOTA_ITEM_MAX - 1 do
		local item = thisEntity:GetItemInSlot( i )
		if item and item:GetAbilityName() == "item_shivas_guard" then
			self.shivasAbility = item
		end
		if item and item:GetAbilityName() == "item_phase_boots" then
			self.phaseAbility = item
		end
	end

	self.concoctionThrowAbility = thisEntity:FindAbilityByName( "alchemist_unstable_concoction_throw" )
	self.chemicalRageAbility = thisEntity:FindAbilityByName( "alchemist_chemical_rage" )

	if self.concoctionAbility and self.concoctionAbility:IsFullyCastable() then
		self.startConcoctionTime = GameRules:GetGameTime()
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.concoctionAbility:entindex(),
		}
		return order
	end

	return nil
end

BehaviorConcoction.Continue = BehaviorConcoction.Begin

function BehaviorConcoction:End()
	thisEntity.bInConcontion = false
end

function BehaviorConcoction:IsDone()
	return ( self.startConcoctionTime == nil )
end

function BehaviorConcoction:Think( )
	if self.startConcoctionTime == nil then
		return nil
	end

	--print( "BehaviorConcoction:Think( )" )
	--print( "-----------------------------------" )
	--print( "self.startConcoctionTime == " .. self.startConcoctionTime )
	--print( "GameRules:GetGameTime() == " .. GameRules:GetGameTime() )

	-- reacquire target if possible
	if thisEntity.hTarget == nil or not thisEntity.hTarget:IsAlive() then
		SelectNewTarget()
		if thisEntity.hTarget == nil then
			-- No target? Move to last valid target position
			local order =
			{
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = thisEntity.lastTargetPosition
			}
			return order
		end
	end

	thisEntity.lastTargetPosition = thisEntity.hTarget:GetAbsOrigin()

	-- if we missed our cast window for some reason
	if GameRules:GetGameTime() >= ( self.startConcoctionTime + self.nSelfExplodeTime ) then
		--print( "ending")
		self.startConcoctionTime = nil
		return nil
	end

	-- If we're still waiting to throw, then try to close...
	if GameRules:GetGameTime() < ( self.startConcoctionTime + self.nBrewTime ) then

		-- Cast phase if we can
		if self.phaseAbility and self.phaseAbility:IsFullyCastable() then
			--print( "Casting phase" )
			local order =
			{
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self.phaseAbility:entindex()
			}
			return order
		end

		-- Cast Shiva if we can
		if self.shivasAbility and self.shivasAbility:IsFullyCastable() then
			--print( "Casting shiva" )
			local order =
			{
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self.shivasAbility:entindex()
			}
			return order
		end

	else

		-- Ok, we're able to throw, so lets throw
		if self.concoctionThrowAbility and not self.concoctionThrowAbility:IsHidden() and self.concoctionThrowAbility:IsFullyCastable() then
			--print( "Casting throw" )
			local order =
			{
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				AbilityIndex = self.concoctionThrowAbility:entindex(),
				TargetIndex = thisEntity.hTarget:entindex()
			}

			return order
		end

		-- Otherwise, try to cast chemical rage
		if self.chemicalRageAbility and self.chemicalRageAbility:IsFullyCastable() then
			--print( "Casting Chemical Rage" )
			local order =
			{
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self.chemicalRageAbility:entindex(),
			}
			return order
		end

	end

	-- Nothing better to do? Chase our target
	--print( "Attacking" )
	local order =
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = thisEntity.hTarget:entindex()
	}
	return order

end

--------------------------------------------------------------------------------------------------------

BehaviorAcidSpray = {}

function BehaviorAcidSpray:Evaluate()
	--print( "BehaviorAcidSpray:Evaluate()" )
	local desire = 0

	-- let's not choose this twice in a row
	if behaviorSystem.currentBehavior == self then 
		return desire 
	end

	-- Got to have a target
	if thisEntity.hTarget == nil or not thisEntity.hTarget:IsAlive() or not thisEntity:CanEntityBeSeenByMyTeam( thisEntity.hTarget ) then
		return desire
	end

	self.acidSprayAbility = thisEntity:FindAbilityByName( "alchemist_acid_spray" )
	if self.acidSprayAbility and self.acidSprayAbility:IsFullyCastable() then
		if thisEntity.hTarget:IsStunned() then
			desire = 6
		else
			desire = 4
		end
	end
	
	return desire
end

function BehaviorAcidSpray:Begin()
	--print( "BehaviorAcidSpray:Begin()" )

	if self.acidSprayAbility and self.acidSprayAbility:IsFullyCastable() then
		--print( "Casting Acid Spray" )
		local targetPoint = thisEntity.lastTargetPosition + RandomVector( 100 )
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.acidSprayAbility:entindex(),
			Position = targetPoint
		}
		return order
	end

	return nil
end

BehaviorAcidSpray.Continue = BehaviorAcidSpray.Begin

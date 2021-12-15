--[[ Beastmaster AI ]]

require( "ai/ai_core" )

function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
    behaviorSystem = AICore:CreateBehaviorSystem( thisEntity, { BehaviorNone, BehaviorWildAxes, BehaviorPrimalRoar } )
end

function AIThink() -- For some reason AddThinkToEnt doesn't accept member functions
	return behaviorSystem:Think( )
end

--------------------------------------------------------------------------------------------------------

BehaviorNone = {}

function BehaviorNone:Evaluate()
	return 1 -- must return a value > 0, so we have a default
end

function BehaviorNone:Begin()

	local orders = nil
	local hTarget = AICore:ClosestEnemyHeroInRange( thisEntity, 1000, false, true )
	if hTarget ~= nil then
		thisEntity.lastTargetPosition = hTarget:GetAbsOrigin()
		hTarget:MakeVisibleDueToAttack( DOTA_TEAM_BADGUYS, 100 )
		orders =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = hTarget:entindex()
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

BehaviorWildAxes = {}

function BehaviorWildAxes:Evaluate()
	--print( "BehaviorWildAxes:Evaluate()" )
	local desire = 0

	-- let's not choose this twice in a row
	if behaviorSystem.currentBehavior == self then 
		return desire 
	end

	self.wildAxesAbility = thisEntity:FindAbilityByName( "beastmaster_wild_axes" )
	if self.wildAxesAbility and self.wildAxesAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies >= 0 )  then
			for _,hUnit in pairs( enemies ) do
				if hUnit ~= nil and hUnit:IsAlive() then
					local hGushModifier = hUnit:FindModifierByName( "modifier_beastmaster_wild_axes" )
					if hGushModifier ~= nil then
						--print("Enemy is already axed")
						desire = 0
					else
						desire = #enemies + 1
					end
				end
			end
		end
	end

	return desire
end

function BehaviorWildAxes:Begin()
	--print( "BehaviorWildAxes:Begin()" )
	if self.wildAxesAbility and self.wildAxesAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		if #enemies == 0 then
			return nil
		end
		thisEntity:AddNewModifier( thisEntity, nil, "modifier_provide_vision", { duration = 1.1 } )
		local target = enemies[#enemies]
		local targetPoint = target:GetOrigin() + RandomVector( 100 )
		local order =
			{
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				Position = targetPoint,
				AbilityIndex = self.wildAxesAbility:entindex(),
				Queue = false,
			}
			return order
	end

	return nil
end

BehaviorWildAxes.Continue = BehaviorWildAxes.Begin

--------------------------------------------------------------------------------------------------------

BehaviorPrimalRoar = {}

function BehaviorPrimalRoar:Evaluate()
	--print( "BehaviorPrimalRoar:Evaluate()" )
	local desire = 0

	self.primalRoarAbility = thisEntity:FindAbilityByName( "beastmaster_primal_roar" )
	if self.primalRoarAbility and self.primalRoarAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( thisEntity:GetHealthPercent() > 75 ) then
			return desire
		end
		if ( #enemies >= 0 )  then
			for _,hUnit in pairs( enemies ) do
				if hUnit ~= nil and hUnit:IsAlive() then
					local hStunModifier = hUnit:FindModifierByName( "modifier_stunned" )
					if hStunModifier ~= nil then
						--print("Enemy is already stunned")
						desire = 0
					else
						desire = #enemies + 1
					end
				end
			end
		end
	end
	
	return desire
end

function BehaviorPrimalRoar:Begin()
	--print( "BehaviorPrimalRoar:Begin()" )
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	if #enemies == 0 then
		return nil
	end
	local target = enemies[#enemies]
	if self.primalRoarAbility and self.primalRoarAbility:IsFullyCastable() then
		--print( "Casting Primal Roar" )
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			TargetIndex = target:entindex(),
			AbilityIndex = self.primalRoarAbility:entindex(),
			Queue = false,
		}
		return order
	end

	return nil
end

BehaviorPrimalRoar.Continue = BehaviorPrimalRoar.Begin

--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorNone, BehaviorWildAxes, BehaviorPrimalRoar }

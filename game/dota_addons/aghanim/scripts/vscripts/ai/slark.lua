--[[ Slark Peon AI ]]

require( "ai/ai_core" )

function Spawn( entityKeyValues )
	thisEntity.vNagaPosition = nil
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
    behaviorSystem = AICore:CreateBehaviorSystem( thisEntity, { BehaviorNone, BehaviorDarkPact, BehaviorPounce, BehaviorShadowDance, BehaviorRunAway } )
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
	local hTarget = AICore:ClosestEnemyHeroInRange( thisEntity, thisEntity:GetDayTimeVisionRange(), false, true )
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

BehaviorDarkPact = {}

function BehaviorDarkPact:Evaluate()
	local desire = 0
	
	-- let's not choose this twice in a row
	if behaviorSystem.currentBehavior == self then 
		return desire 
	end

	self.darkPactAbility = thisEntity:FindAbilityByName( "slark_dark_pact" )
	if not self.darkPactAbility or not self.darkPactAbility:IsFullyCastable() then
		return desire
	end

	local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies >= 0 )  then
			for _,hUnit in pairs( enemies ) do
				if hUnit ~= nil and hUnit:IsAlive() then
					local hDarkPactModifier = hUnit:FindModifierByName( "modifier_slark_dark_pact" )
					if hDarkPactModifier ~= nil then
						--print("Enemy is already Dark Pacted")
						desire = 0
					else
						local nRandomInt = RandomInt(1,5)
						if nRandomInt == 1 then
							desire = #enemies + 1
						end
					end
				end
			end
		end

	return desire
end

function BehaviorDarkPact:Begin()
	--print( "BehaviorDarkPact:Begin()" )
	if self.darkPactAbility and self.darkPactAbility:IsFullyCastable() then
		local order = 
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.darkPactAbility:entindex(),
		}
		return order
	end
	return nil

end

BehaviorDarkPact.Continue = BehaviorDarkPact.Begin

--------------------------------------------------------------------------------------------------------

BehaviorPounce = {}

function BehaviorPounce:Evaluate()
	--print( "BehaviorPounce:Evaluate()" )
	local desire = 0

	self.pounceAbility = thisEntity:FindAbilityByName( "slark_pounce" )
	if self.pounceAbility and self.pounceAbility:IsFullyCastable() then
		local hGoal = Entities:FindByName( nil, "slark_room_center" )
		local vGoalPos = hGoal:GetOrigin()
		local goalDifference = vGoalPos - thisEntity:GetOrigin()
		local goalDistance = goalDifference:Length()
		if goalDistance > 1500 then
			--print("Too close to edge of room")
			return desire
		end
		local nRange = 700
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, nRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		for _,enemy in pairs(enemies) do
			local enemyVec = enemy:GetOrigin() - thisEntity:GetOrigin()
			local myForward = thisEntity:GetForwardVector()
			local dotProduct = enemyVec:Dot( myForward ) 
			local enemyDesire = 0
			if dotProduct > 0 then
				enemyDesire = 8
			end
			local distance = enemyVec:Length2D()
			if distance > 400 then
				desire = enemyDesire
				self.target = enemy
			end
		end
	end

	return desire
end

function BehaviorPounce:Begin()
	--print( "BehaviorPounce:Begin()" )

	if self.target and self.target:IsAlive() then
		if self.pounceAbility and self.pounceAbility:IsFullyCastable() then
			--print( "Casting Star Fall" )
			local order =
			{
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self.pounceAbility:entindex(),
				Queue = false,
			}
			return order
		end
	end

	return nil
end

BehaviorPounce.Continue = BehaviorPounce.Begin

--------------------------------------------------------------------------------------------------------

BehaviorShadowDance = {}

function BehaviorShadowDance:Evaluate()
	--print( "BehaviorShadowDance:Evaluate()" )
	local desire = 0

	local retreatPoints = thisEntity.Encounter:GetRetreatPoints()
	if retreatPoints == nil then
		print( "*** WARNING: This AI requires info_targets named retreat_point in the map " .. thisEntity.Encounter:GetRoom():GetName() )
		return 0
	end

	local happyPlaceIndex =  RandomInt( 1, #retreatPoints )
	self.escapePoint = retreatPoints[ happyPlaceIndex ]:GetAbsOrigin()

	self.shadowDanceAbility = thisEntity:FindAbilityByName( "slark_shadow_dance" )
	local nRange = 300
	local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, nRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
	if self.shadowDanceAbility and self.shadowDanceAbility:IsFullyCastable() then
		if ( thisEntity:GetHealthPercent() < 25 ) and ( #enemies >= 0 ) then
			desire = #enemies + 1
		end
	end
	
	return desire
end

function BehaviorShadowDance:Begin()
	--print( "BehaviorShadowDance:Begin()" )
	self.startEscapeTime = GameRules:GetGameTime()

	if self.shadowDanceAbility and self.shadowDanceAbility:IsFullyCastable() then
		--print( "Casting Shadow Dance" )
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.shadowDanceAbility:entindex(),
		}
		return order
	end

	return nil
end

function BehaviorShadowDance:IsDone( )
	return ( GameRules:GetGameTime() > ( self.startEscapeTime + 6 ) ) or
		( ( thisEntity:GetAbsOrigin() - self.escapePoint ):Length2D() < 200 )
end

function BehaviorShadowDance:Think( )
	-- keep moving towards our escape point
	return
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = self.escapePoint
	}

end

BehaviorShadowDance.Continue = BehaviorShadowDance.Begin

--------------------------------------------------------------------------------------------------------

BehaviorRunAway = {}

function BehaviorRunAway:Evaluate()
	local desire = 0
	local retreatPoints = thisEntity.Encounter:GetRetreatPoints()
	if retreatPoints == nil then
		print( "*** WARNING: This AI requires info_targets named retreat_point in the map " .. thisEntity.Encounter:GetRoom():GetName() )
		return 0
	end

	local creatures = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	for _,hUnit in pairs( creatures ) do
		if hUnit ~= nil and hUnit:IsAlive() then
			local hSongModifier = hUnit:FindModifierByName( "modifier_naga_siren_song_of_the_siren_aura" )
			if hSongModifier ~= nil then
				--print("Naga Siren is singing!")
				thisEntity.vNagaPosition = hUnit:GetAbsOrigin()
				desire = 8
			end
		end
	end

	return desire
end

function BehaviorRunAway:Begin()
	--print( "BehaviorRunAway:Begin()" )
	self.startEscapeTime = GameRules:GetGameTime()

	-- Move towards Naga
	return
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity.vNagaPosition
	}

end

function BehaviorRunAway:IsDone( )
	return ( GameRules:GetGameTime() > ( self.startEscapeTime + 6 ) ) or
		( ( thisEntity:GetAbsOrigin() - thisEntity.vNagaPosition ):Length2D() < 200 )
end

function BehaviorRunAway:Think( )
	-- keep moving towards our escape point
	return
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity.vNagaPosition
	}

end

BehaviorRunAway.Continue = BehaviorRunAway.Begin

--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorNone, BehaviorDarkPact, BehaviorPounce, BehaviorShadowDance, BehaviorRunAway }

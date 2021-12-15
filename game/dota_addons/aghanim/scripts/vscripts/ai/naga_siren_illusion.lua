--[[ Naga Siren Illusion AI ]]

require( "ai/ai_core" )

function Spawn( entityKeyValues )
	thisEntity.nIllusionsCreated = 0
	thisEntity.nMaxIllusions = 10
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
    behaviorSystem = AICore:CreateBehaviorSystem( thisEntity, { BehaviorNone, BehaviorRipTide, BehaviorRunAway } )
	
    --[[ Turn on Radiance
	for i = 0, DOTA_ITEM_MAX - 1 do
		local item = thisEntity:GetItemInSlot( i )
		if item and item:GetAbilityName() == "item_radiance" then
			thisEntity.RadianceAbility = item
		end
	end
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.RadianceAbility:entindex(),
		Queue = false,
	})
	]]
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

BehaviorRipTide = {}

function BehaviorRipTide:Evaluate()
	--print( "BehaviorRipTide:Evaluate()" )
	local desire = 0

	-- let's not choose this twice in a row
	if behaviorSystem.currentBehavior == self then 
		return desire 
	end

	self.ripTideAbility = thisEntity:FindAbilityByName( "naga_siren_rip_tide" )
	if self.ripTideAbility and self.ripTideAbility:IsFullyCastable() then
		local nRange = 300
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, nRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies > 1 )  then
			desire = #enemies + 1
		end
	end
	
	return desire
end

function BehaviorRipTide:Begin()
	--print( "BehaviorRipTide:Begin()" )

	if self.ripTideAbility and self.ripTideAbility:IsFullyCastable() then
		--print( "Casting Star Fall" )
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.ripTideAbility:entindex(),
		}
		return order
	end

	return nil
end

BehaviorRipTide.Continue = BehaviorRipTide.Begin

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

AICore.possibleBehaviors = { BehaviorNone, BehaviorRipTide, BehaviorRunAway }

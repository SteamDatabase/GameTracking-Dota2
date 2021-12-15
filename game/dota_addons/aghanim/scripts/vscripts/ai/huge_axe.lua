--[[ Huge Axe AI ]]

require( "ai/ai_core" )

function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
    behaviorSystem = AICore:CreateBehaviorSystem( thisEntity, { BehaviorNone, BehaviorBerserkersCall, BehaviorCullingBlade, BehaviorBlademail } )
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
	local hTarget = AICore:ClosestEnemyHeroInRange( thisEntity, 2000, false, true )
	if hTarget ~= nil then
		thisEntity.lastTargetPosition = hTarget:GetAbsOrigin()
		hTarget:MakeVisibleDueToAttack( DOTA_TEAM_BADGUYS, 100 )
		orders =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = thisEntity.lastTargetPosition
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

BehaviorBerserkersCall = {}

function BehaviorBerserkersCall:Evaluate()
	--print( "BehaviorBerserkersCall:Evaluate()" )
	local desire = 0

	-- let's not choose this twice in a row
	if behaviorSystem.currentBehavior == self then 
		return desire 
	end

	self.hBerserkersCallAbility = thisEntity:FindAbilityByName( "axe_berserkers_call" )
	if self.hBerserkersCallAbility and self.hBerserkersCallAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies >= 0 )  then
			desire = #enemies + 1
		end
	end

	return desire
end

function BehaviorBerserkersCall:Begin()
	--print( "BehaviorBerserkersCall:Begin()" )
	if self.hBerserkersCallAbility and self.hBerserkersCallAbility:IsFullyCastable() then
		local order =
			{
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self.hBerserkersCallAbility:entindex(),
				Queue = false,
			}
		return order
	end

	return nil
end

BehaviorBerserkersCall.Continue = BehaviorBerserkersCall.Begin

--------------------------------------------------------------------------------------------------------

BehaviorCullingBlade = {}

function BehaviorCullingBlade:Evaluate()
	--print( "BehaviorCullingBlade:Evaluate()" )
	local desire = 0

	self.hCullingBladeAbility = thisEntity:FindAbilityByName( "axe_culling_blade" )
	if self.hCullingBladeAbility and self.hCullingBladeAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies >= 0 )  then
			desire = #enemies + 1
		end
	end

	return desire
end

function BehaviorCullingBlade:Begin()
	--print( "BehaviorCullingBlade:Begin()" )
	if self.hCullingBladeAbility and self.hCullingBladeAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		for _,target in pairs( enemies ) do
			if target:GetHealth() <= 750 then
				local order =
				{
					UnitIndex = thisEntity:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					TargetIndex = target:entindex(),
					AbilityIndex = self.hCullingBladeAbility:entindex(),
					Queue = false,
				}
				return order
			end
		end
	end

	return nil
end

BehaviorCullingBlade.Continue = BehaviorCullingBlade.Begin

--------------------------------------------------------------------------------------------------------

BehaviorBlademail = {}

function BehaviorBlademail:Evaluate()
	--print( "BehaviorBlademail:Evaluate()" )
	local desire = 0
	for i = 0, DOTA_ITEM_MAX - 1 do
		local item = thisEntity:GetItemInSlot( i )
		if item and item:GetAbilityName() == "item_aghsfort_creature_blade_mail" then
			self.hBladeMailAbility = item
		end
	end
	if self.hBladeMailAbility and self.hBladeMailAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( thisEntity:GetHealthPercent() < 90 ) then
			if ( #enemies >= 0 )  then
				desire = #enemies + 1
			end
		end
	end
	

	return desire
end

function BehaviorBlademail:Begin()
	--print( "BehaviorBlademail:Begin()" )
	if self.hBladeMailAbility and self.hBladeMailAbility:IsFullyCastable() then
		--print( "Casting Blade Mail" )
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.hBladeMailAbility:entindex(),
		}
		return order
	end

	return nil
end

BehaviorBlademail.Continue = BehaviorBlademail.Begin

--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorNone, BehaviorBerserkersCall, BehaviorCullingBlade, BehaviorBlademail }

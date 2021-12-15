--[[ Mars AI ]]

require( "ai/ai_core" )

function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
    behaviorSystem = AICore:CreateBehaviorSystem( thisEntity, { BehaviorNone, BehaviorFireSpear, BehaviorGodsRebuke, BehaviorArena, BehaviorShivas, BehaviorBlademail } )
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

BehaviorFireSpear = {}

function BehaviorFireSpear:Evaluate()
	--print( "BehaviorFireSpear:Evaluate()" )
	local desire = 0

	self.hFireSpearAbility = thisEntity:FindAbilityByName( "mars_spear" )
	if self.hFireSpearAbility and self.hFireSpearAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies >= 0 )  then
			desire = #enemies + 1
		end
	end

	return desire
end

function BehaviorFireSpear:Begin()
	print( "BehaviorFireSpear:Begin()" )
	if self.hFireSpearAbility and self.hFireSpearAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		local target = enemies[#enemies]
		local targetPoint = target:GetOrigin() + RandomVector( 25 )
		local order =
			{
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				Position = targetPoint,
				AbilityIndex = self.hFireSpearAbility:entindex(),
				Queue = false,
			}
		return order
	end

	return nil
end

BehaviorFireSpear.Continue = BehaviorFireSpear.Begin

--------------------------------------------------------------------------------------------------------

BehaviorGodsRebuke = {}

function BehaviorGodsRebuke:Evaluate()
	--print( "BehaviorGodsRebuke:Evaluate()" )
	local desire = 0

	self.hGodsRebukeAbility = thisEntity:FindAbilityByName( "mars_gods_rebuke" )
	if self.hGodsRebukeAbility and self.hGodsRebukeAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies >= 0 )  then
			desire = #enemies + 1
		end
	end

	return desire
end

function BehaviorGodsRebuke:Begin()
	print( "BehaviorGodsRebuke:Begin()" )
	if self.hGodsRebukeAbility and self.hGodsRebukeAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		local target = enemies[#enemies]
		local targetPoint = target:GetOrigin() + RandomVector( 25 )
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = targetPoint,
			AbilityIndex = self.hGodsRebukeAbility:entindex(),
			Queue = false,
		}
		return order
	end

	return nil
end

BehaviorGodsRebuke.Continue = BehaviorGodsRebuke.Begin

--------------------------------------------------------------------------------------------------------

BehaviorArena = {}

function BehaviorArena:Evaluate()
	--print( "BehaviorArena:Evaluate()" )
	local desire = 0

	self.hArenaAbility = thisEntity:FindAbilityByName( "mars_arena_of_blood" )
	if self.hArenaAbility and self.hArenaAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 1400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( thisEntity:GetHealthPercent() < 50 ) then
			if ( #enemies >= 0 )  then
				desire = #enemies + 1
			end
		end
	end

	return desire
end

function BehaviorArena:Begin()
	--print( "BehaviorArena:Begin()" )
	if self.hArenaAbility and self.hArenaAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 1400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		local target = enemies[#enemies]
		local targetPoint = target:GetOrigin() + RandomVector( 25 )
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = targetPoint,
			AbilityIndex = self.hArenaAbility:entindex(),
			Queue = false,
		}
		return order
	end

	return nil
end

BehaviorArena.Continue = BehaviorArena.Begin

--------------------------------------------------------------------------------------------------------

BehaviorShivas = {}

function BehaviorShivas:Evaluate()
	--print( "BehaviorShivas:Evaluate()" )
	local desire = 0
	for i = 0, DOTA_ITEM_MAX - 1 do
		local item = thisEntity:GetItemInSlot( i )
		if item and item:GetAbilityName() == "item_shivas_guard" then
			self.hShivasAbility = item
		end
	end
	if self.hShivasAbility and self.hShivasAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( thisEntity:GetHealthPercent() < 75 ) then
			if ( #enemies >= 0 )  then
				desire = #enemies + 1
			end
		end
	end
	

	return desire
end

function BehaviorShivas:Begin()
	--print( "BehaviorShivas:Begin()" )
	if self.hShivasAbility and self.hShivasAbility:IsFullyCastable() then
		--print( "Casting Shivas" )
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.hShivasAbility:entindex(),
		}
		return order
	end

	return nil
end

BehaviorShivas.Continue = BehaviorShivas.Begin

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

AICore.possibleBehaviors = { BehaviorNone, BehaviorFireSpear, BehaviorGodsRebuke, BehaviorArena, BehaviorShivas, BehaviorBlademail }

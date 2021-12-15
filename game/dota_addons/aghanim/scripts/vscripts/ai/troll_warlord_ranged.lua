--[[ Troll Warlord Ranged AI ]]

require( "ai/ai_core" )

function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
    behaviorSystem = AICore:CreateBehaviorSystem( thisEntity, { BehaviorNone, BehaviorWhirlingAxes, BehaviorBattleTrance, BehaviorBKB } )
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

BehaviorWhirlingAxes = {}

function BehaviorWhirlingAxes:Evaluate()
	--print( "BehaviorWhirlingAxes:Evaluate()" )
	local desire = 0

	-- let's not choose this twice in a row
	if behaviorSystem.currentBehavior == self then 
		return desire 
	end

	self.whirlingAxesAbility = thisEntity:FindAbilityByName( "troll_warlord_whirling_axes_ranged" )
	if self.whirlingAxesAbility and self.whirlingAxesAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies >= 0 )  then
			desire = #enemies + 1
		end
	end

	return desire
end

function BehaviorWhirlingAxes:Begin()
	--print( "BehaviorWhirlingAxes:Begin()" )
	if self.whirlingAxesAbility and self.whirlingAxesAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		if #enemies == 0 then
			return nil
		end
		local target = enemies[#enemies]
		local targetPoint = target:GetOrigin() + RandomVector( 100 )
		local order =
			{
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				TargetIndex = target:entindex(),
				AbilityIndex = self.whirlingAxesAbility:entindex(),
				Queue = false,
			}
		return order
	end

	return nil
end

BehaviorWhirlingAxes.Continue = BehaviorWhirlingAxes.Begin

--------------------------------------------------------------------------------------------------------

BehaviorBattleTrance = {}

function BehaviorBattleTrance:Evaluate()
	--print( "BehaviorBattleTrance:Evaluate()" )
	local desire = 0

	self.battleTranceAbility = thisEntity:FindAbilityByName( "troll_warlord_battle_trance" )
	if self.battleTranceAbility and self.battleTranceAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( thisEntity:GetHealthPercent() < 30 ) then
			if ( #enemies >= 0 )  then
				desire = #enemies + 1
			end
		end
	end

	return desire
end

function BehaviorBattleTrance:Begin()
	--print( "BehaviorBattleTrance:Begin()" )
	if self.battleTranceAbility and self.battleTranceAbility:IsFullyCastable() then
		--print( "Casting Battle Trance" )
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.battleTranceAbility:entindex(),
		}
		return order
	end

	return nil
end

BehaviorBattleTrance.Continue = BehaviorBattleTrance.Begin

--------------------------------------------------------------------------------------------------------

BehaviorBKB = {}

function BehaviorBKB:Evaluate()
	--print( "BehaviorBKB:Evaluate()" )
	local desire = 0
	for i = 0, DOTA_ITEM_MAX - 1 do
		local item = thisEntity:GetItemInSlot( i )
		if item and item:GetAbilityName() == "item_creature_black_king_bar" then
			self.blackKingBarAbility = item
		end
	end
	if self.blackKingBarAbility and self.blackKingBarAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( thisEntity:GetHealthPercent() < 50 ) then
			if ( #enemies >= 0 )  then
				desire = #enemies + 1
			end
		end
	end
	

	return desire
end

function BehaviorBKB:Begin()
	--print( "BehaviorBKB:Begin()" )
	if self.blackKingBarAbility and self.blackKingBarAbility:IsFullyCastable() then
		--print( "Casting Primal Roar" )
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.blackKingBarAbility:entindex(),
		}
		return order
	end

	return nil
end

BehaviorBKB.Continue = BehaviorBKB.Begin

--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorNone, BehaviorWhirlingAxes, BehaviorBattleTrance, BehaviorBKB }

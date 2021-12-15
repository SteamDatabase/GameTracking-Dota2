--[[ Year Beast AI ]]

require( "ai/ai_core" )

function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
    behaviorSystem = AICore:CreateBehaviorSystem( thisEntity, { BehaviorNone, BehaviorSmash } )
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
		if thisEntity:GetInitialGoalEntity() == nil then
			local hWaypoint = Entities:FindByClassnameNearest( "path_track", thisEntity:GetOrigin(), 2000.0 )
			if hWaypoint ~= nil then
				--print( "Patrolling to " .. hWaypoint:GetName() )
				thisEntity:SetInitialGoalEntity( hWaypoint )
			end
		end
	end

	return orders
end

BehaviorNone.Continue = BehaviorNone.Begin

--------------------------------------------------------------------------------------------------------

BehaviorSmash = {}

function BehaviorSmash:Evaluate()
	--print( "BehaviorSmash:Evaluate()" )
	local desire = 0

	-- let's not choose this twice in a row
	if behaviorSystem.currentBehavior == self then 
		return desire 
	end

	self.smashAbility = thisEntity:FindAbilityByName( "year_beast_smash" )
	if self.smashAbility and self.smashAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies >= 0 )  then
			for _,hUnit in pairs( enemies ) do
				if hUnit ~= nil and hUnit:IsAlive() then
					local hStunModifier = hUnit:FindModifierByName( "modifier_polar_furbolg_ursa_warrior_thunder_clap" )
					if hStunModifier ~= nil then
						--print("Enemy is already smashed")
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

function BehaviorSmash:Begin()
	--print( "BehaviorSmash:Begin()" )
	if self.smashAbility and self.smashAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		if #enemies == 0 then
			return nil
		end
		thisEntity:AddNewModifier( thisEntity, nil, "modifier_provide_vision", { duration = 1.1 } )
		local order =
			{
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self.smashAbility:entindex(),
				Queue = false,
			}
			return order
	end

	return nil
end

BehaviorSmash.Continue = BehaviorSmash.Begin

--------------------------------------------------------------------------------------------------------
--[[
BehaviorMaskOfMadness = {}

function BehaviorMaskOfMadness:Evaluate()
	--print( "BehaviorMaskOfMadness:Evaluate()" )
	local desire = 0
	for i = 0, DOTA_ITEM_MAX - 1 do
		local item = thisEntity:GetItemInSlot( i )
		if item and item:GetAbilityName() == "item_mask_of_madness" then
			self.hMaskOfMadnessAbility = item
		end
	end
	if self.hMaskOfMadnessAbility and self.hMaskOfMadnessAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( thisEntity:GetHealthPercent() < 50 ) then
			if ( #enemies >= 0 )  then
				desire = #enemies + 1
			end
		end
	end
	

	return desire
end

function BehaviorMaskOfMadness:Begin()
	--print( "BehaviorMaskOfMadness:Begin()" )
	if self.hMaskOfMadnessAbility and self.hMaskOfMadnessAbility:IsFullyCastable() then
		--print( "Casting Primal Roar" )
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.hMaskOfMadnessAbility:entindex(),
		}
		return order
	end

	return nil
end

BehaviorMaskOfMadness.Continue = BehaviorMaskOfMadness.Begin
]]
--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorNone, BehaviorSmash }

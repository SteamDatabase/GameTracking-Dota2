--[[ Tidehunter Miniboss AI ]]

require( "ai/ai_core" )

function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
    behaviorSystem = AICore:CreateBehaviorSystem( thisEntity, { BehaviorNone, BehaviorGush, BehaviorAnchorSmash } )
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
	local hTarget = AICore:ClosestEnemyHeroInRange( thisEntity, 1500, false, true )
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

BehaviorGush = {}

function BehaviorGush:Evaluate()
	--print( "BehaviorGush:Evaluate()" )
	local desire = 0

	-- let's not choose this twice in a row
	if behaviorSystem.currentBehavior == self then 
		return desire 
	end

	self.gushAbility = thisEntity:FindAbilityByName( "creature_tidehunter_gush" )
	if self.gushAbility and self.gushAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies >= 0 )  then
			for _,hUnit in pairs( enemies ) do
				if hUnit ~= nil and hUnit:IsAlive() then
					local hGushModifier = hUnit:FindModifierByName( "modifier_tidehunter_gush" )
					if hGushModifier ~= nil then
						--print("Enemy is already gushed")
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

function BehaviorGush:Begin()
	--print( "BehaviorGush:Begin()" )
	if self.gushAbility and self.gushAbility:IsFullyCastable() then
		local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		if #hEnemies == 0 then
			return nil
		end
		local hTarget = hEnemies[#hEnemies]
		local order =
			{
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				TargetIndex = hTarget:entindex(),
				AbilityIndex = self.gushAbility:entindex(),
				Queue = false,
			}
			return order
	end

	return nil
end

BehaviorGush.Continue = BehaviorGush.Begin

--------------------------------------------------------------------------------------------------------

BehaviorAnchorSmash = {}

function BehaviorAnchorSmash:Evaluate()
	--print( "BehaviorAnchorSmash:Evaluate()" )
	local desire = 0

	self.anchorSmashAbility = thisEntity:FindAbilityByName( "tidehunter_anchor_smash" )
	if self.anchorSmashAbility and self.anchorSmashAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies >= 0 )  then
			desire = #enemies + 1
		end
	end
	
	return desire
end

function BehaviorAnchorSmash:Begin()
	--print( "BehaviorAnchorSmash:Begin()" )

	if self.anchorSmashAbility and self.anchorSmashAbility:IsFullyCastable() then
		--print( "Casting Anchor Smash" )
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.anchorSmashAbility:entindex()
		}
		return order
	end

	return nil
end

BehaviorAnchorSmash.Continue = BehaviorAnchorSmash.Begin

--------------------------------------------------------------------------------------------------------
--[[ Ravage now placed in passive modifier
BehaviorRavage = {}

function BehaviorRavage:Evaluate()
	--print( "BehaviorRavage:Evaluate()" )
	local desire = 0

	self.ravageAbility = thisEntity:FindAbilityByName( "tidehunter_ravage" )
	if self.ravageAbility and self.ravageAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( thisEntity:GetHealthPercent() < 75 ) then
			if ( #enemies > 1 )  then
				desire = #enemies + 1
			end
		end
	end
	
	return desire
end

function BehaviorRavage:Begin()
	--print( "BehaviorRavage:Begin()" )

	if self.ravageAbility and self.ravageAbility:IsFullyCastable() then
		--print( "Casting Ravage" )
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.ravageAbility:entindex()
		}
		return order
	end

	return nil
end

BehaviorRavage.Continue = BehaviorRavage.Begin
]]
--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorNone, BehaviorGush, BehaviorAnchorSmash }

--[[ Brewmaster AI ]]

require( "ai/ai_core" )

function Spawn( entityKeyValues )
	thisEntity.bWantsToSplit = false
	thisEntity.startSplitTime = -1
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
    behaviorSystem = AICore:CreateBehaviorSystem( thisEntity, { BehaviorNone, BehaviorThunderClap, BehaviorPrimalSplit } )
end

function AIThink()
	return behaviorSystem:Think( )
end

--------------------------------------------------------------------------------------------------------

BehaviorNone = {}

function BehaviorNone:Evaluate()
	return 1 -- must return a value > 0, so we have a default
end

function BehaviorNone:Begin()
	if thisEntity.bWantsToSplit then
		return nil
	end

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

BehaviorThunderClap = {}

function BehaviorThunderClap:Evaluate()
	--print( "BehaviorThunderClap:Evaluate()" )
	local desire = 0
	if thisEntity.bWantsToSplit then
		return desire
	end

	self.thunderClapAbility = thisEntity:FindAbilityByName( "aghsfort_brewmaster_thunderclap" )
	if self.thunderClapAbility and self.thunderClapAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies >= 0 )  then
			for _,hUnit in pairs( enemies ) do
				if hUnit ~= nil and hUnit:IsAlive() then
					local hGushModifier = hUnit:FindModifierByName( "modifier_brewmaster_thunder_clap" )
					if hGushModifier ~= nil then
						--print("Enemy is already thunder clapped")
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

function BehaviorThunderClap:Begin()
	--print( "BehaviorThunderClap:Begin()" )
	if self.thunderClapAbility and self.thunderClapAbility:IsFullyCastable() then
		local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		if #hEnemies == 0 then
			return nil
		end
		local hTarget = hEnemies[#hEnemies]
		local order =
			{
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self.thunderClapAbility:entindex(),
			}
			return order
	end

	return nil
end

BehaviorThunderClap.Continue = BehaviorThunderClap.Begin

--------------------------------------------------------------------------------------------------------

BehaviorPrimalSplit = {}

function BehaviorPrimalSplit:Evaluate()
	--print( "BehaviorPrimalSplit:Evaluate()" )
	local desire = 0
	if thisEntity.bWantsToSplit then
		return 1000000
	end
	-- Bremaster can only use Primal Split once
	self.primalSplitAbility = thisEntity:FindAbilityByName( "aghsfort_brewmaster_primal_split" )
	if self.primalSplitAbility and self.primalSplitAbility:IsFullyCastable() then
		if thisEntity:GetHealthPercent() < 40 and GameRules:GetGameTime() > thisEntity.startSplitTime then
			thisEntity.bWantsToSplit = true
			return 10000
		end
	end
	
	return desire
end

function BehaviorPrimalSplit:Begin()
	--print( "BehaviorPrimalSplit:Begin()" )

	if self.primalSplitAbility and self.primalSplitAbility:IsFullyCastable() and GameRules:GetGameTime() > thisEntity.startSplitTime then
		thisEntity.startSplitTime = GameRules:GetGameTime() + 0.7
		--print( "execute order" )
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.primalSplitAbility:entindex()
		}

		ExecuteOrderFromTable( order )

		return nil
	end

	return nil
end

function BehaviorPrimalSplit:IsDone()
	return true
end

BehaviorPrimalSplit.Continue = BehaviorPrimalSplit.Begin

--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorNone, BehaviorThunderClap, BehaviorPrimalSplit }

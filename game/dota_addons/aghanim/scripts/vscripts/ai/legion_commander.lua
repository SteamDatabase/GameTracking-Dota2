--[[ Legion Commander AI ]]

require( "ai/ai_core" )

function Spawn( entityKeyValues )
	thisEntity.bInDuel = false
	thisEntity.nDuelDuration = 0
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
    behaviorSystem = AICore:CreateBehaviorSystem( thisEntity, { BehaviorNone, BehaviorOverwhelmingOdds, BehaviorBlademail, BehaviorDuel } )
end

function AIThink()
	if thisEntity.bInDuel then
		thisEntity.nDuelDuration = thisEntity.nDuelDuration + 1
	end
	if thisEntity.nDuelDuration > 6 then
		thisEntity.bInDuel = false
		thisEntity.nDuelDuration = 0
	end
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

BehaviorOverwhelmingOdds = {}

function BehaviorOverwhelmingOdds:Evaluate()
	--print( "BehaviorOverwhelmingOdds:Evaluate()" )
	local desire = 0
	--[[ Testing without this ability for now
	self.overwhelmingOddsAbility = thisEntity:FindAbilityByName( "legion_commander_overwhelming_odds" )
	if self.overwhelmingOddsAbility and self.overwhelmingOddsAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies >= 2 )  then
			for _,hUnit in pairs( enemies ) do
				if hUnit ~= nil and hUnit:IsAlive() then
					local hAbilityhModifier = hUnit:FindModifierByName( "modifier_legion_commander_overwhelming_odds" )
					if hAbilityhModifier ~= nil then
						--print("Enemy already has Overwhelming Odds")
						desire = 0
					else
						desire = #enemies + 1
					end
				end
			end
		end
	end
	]]
	return desire
end

function BehaviorOverwhelmingOdds:Begin()
	--print( "BehaviorOverwhelmingOdds:Begin()" )
	if self.overwhelmingOddsAbility and self.overwhelmingOddsAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		if #enemies == 0 then
			return nil
		end
		local target = enemies[#enemies]
		local targetPoint = target:GetOrigin() + RandomVector( 100 )
		local order =
			{
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self.overwhelmingOddsAbility:entindex(),
				Position = targetPoint
			}
			return order
	end

	return nil
end

BehaviorOverwhelmingOdds.Continue = BehaviorOverwhelmingOdds.Begin

--------------------------------------------------------------------------------------------------------

BehaviorBlademail = {}

function BehaviorBlademail:Evaluate()
	--print( "BehaviorBlademail:Evaluate()" )
	local desire = 0
	for i = 0, DOTA_ITEM_MAX - 1 do
		local item = thisEntity:GetItemInSlot( i )
		if item and item:GetAbilityName() == "item_aghsfort_creature_blade_mail" then
			self.blademailAbility = item
		end
	end
	if self.blademailAbility and self.blademailAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( thisEntity:GetHealthPercent() < 100 ) then
			if ( #enemies > 0 )  then
				if thisEntity.bInDuel then
					desire = 8
				else
					desire = #enemies + 1
				end
			end
		end
	end

	return desire
end

function BehaviorBlademail:Begin()
	--print( "BehaviorBlademail:Begin()" )
	if self.blademailAbility and self.blademailAbility:IsFullyCastable() then
		--print( "Casting Blade Mail" )
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.blademailAbility:entindex(),
		}
		return order
	end

	return nil
end

BehaviorBlademail.Continue = BehaviorBlademail.Begin

--------------------------------------------------------------------------------------------------------

BehaviorDuel = {}

function BehaviorDuel:Evaluate()
	--print( "BehaviorDuel:Evaluate()" )
	local desire = 0

	self.duelAbility = thisEntity:FindAbilityByName( "legion_commander_duel" )
	if self.duelAbility and self.duelAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies >= 0 )  then
			for _,hUnit in pairs( enemies ) do
				if hUnit ~= nil and hUnit:IsAlive() then
					local hAbilityModifier = hUnit:FindModifierByName( "modifier_legion_commander_duel" )
					if hAbilityModifier ~= nil then
						--print("Enemy is in a duel")
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

function BehaviorDuel:Begin()
	--print( "BehaviorDuel:Begin()" )
	if self.duelAbility and self.duelAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies >= 0 )  then
			for _,hUnit in pairs( enemies ) do
				if hUnit ~= nil and hUnit:IsAlive() then
					local hAbilityModifier = hUnit:FindModifierByName( "modifier_legion_commander_duel" )
					if hAbilityModifier ~= nil then
						return nil
					else
						--print( "Casting Duel" )
						thisEntity.bInDuel = true
						local target = hUnit
						local order =
							{
								UnitIndex = thisEntity:entindex(),
								OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
								TargetIndex = target:entindex(),
								AbilityIndex = self.duelAbility:entindex()
							}
						return order
					end
				end
			end
		end
	end

	return nil
end

BehaviorDuel.Continue = BehaviorDuel.Begin

--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorNone, BehaviorOverwhelmingOdds, BehaviorBlademail, BehaviorDuel }

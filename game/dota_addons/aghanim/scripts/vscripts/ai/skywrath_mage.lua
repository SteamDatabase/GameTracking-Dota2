--[[ Skywrath Mage AI ]]

require( "ai/ai_core" )

function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
    behaviorSystem = AICore:CreateBehaviorSystem( thisEntity, { BehaviorNone, BehaviorMysticFlare } )
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

BehaviorMysticFlare = {}

function BehaviorMysticFlare:Evaluate()
	--print( "BehaviorMysticFlare:Evaluate()" )
	local desire = 0

	self.mysticFlareAbility = thisEntity:FindAbilityByName( "skywrath_mage_mystic_flare" )
	if self.mysticFlareAbility and self.mysticFlareAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies >= 0 )  then
			for _,hUnit in pairs( enemies ) do
				if hUnit ~= nil and hUnit:IsAlive() then
					local hAbilityModifier = hUnit:FindModifierByName( "modifier_skywrath_mage_mystic_flare" )
					local hDuelModifier = hUnit:FindModifierByName( "modifier_legion_commander_duel" )
					if hAbilityModifier ~= nil then
						--print("Enemy is being Mystic Flared")
						desire = 0
					elseif hDuelModifier ~= nil then
						--print("Enemy is in a Duel")
						desire = 8
					else
						desire = #enemies + 3
					end
				end
			end
		end
	end
	
	return desire
end

function BehaviorMysticFlare:Begin()
	--print( "BehaviorMysticFlare:Begin()" )
	if self.mysticFlareAbility and self.mysticFlareAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies >= 0 )  then
			for _,hUnit in pairs( enemies ) do
				if hUnit ~= nil and hUnit:IsAlive() then
					local hAbilityhModifier = hUnit:FindModifierByName( "modifier_legion_commander_duel" )
					if hAbilityhModifier ~= nil then
						--print( "Casting Mystic Flare" )
						local target = hUnit
						local targetPoint = target:GetAbsOrigin()
						local order =
							{
								UnitIndex = thisEntity:entindex(),
								OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
								AbilityIndex = self.mysticFlareAbility:entindex(),
								Position = targetPoint,
							}
						return order
					else
						return nil
					end
				end
			end
		end
	end

	return nil
end

BehaviorMysticFlare.Continue = BehaviorMysticFlare.Begin

--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorNone, BehaviorMysticFlare }

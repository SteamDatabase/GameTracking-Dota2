--[[ Brewling Earth AI ]]

require( "ai/ai_core" )

function Spawn( entityKeyValues )
	thisEntity.bInitialized = false
	if not thisEntity.bInitialized then
		thisEntity.vInitialSpawnPos = thisEntity:GetOrigin()
		thisEntity.bInitialized = true
	end
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
    behaviorSystem = AICore:CreateBehaviorSystem( thisEntity, { BehaviorNone, BehaviorThunderClap, BehaviorRunAway } )
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

BehaviorThunderClap = {}

function BehaviorThunderClap:Evaluate()
	--print( "BehaviorThunderClap:Evaluate()" )
	local desire = 0

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

BehaviorRunAway = {}

function BehaviorRunAway:Evaluate()
	local desire = 0

	-- let's not choose this twice in a row, or even too close to another escape
	if behaviorSystem.currentBehavior == self or 
		( self.startEscapeTime ~= nil and ( ( GameRules:GetGameTime() - self.startEscapeTime ) < 3 ) ) then
		return desire
	end

	self.escapePoint = thisEntity.vInitialSpawnPos

	local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
	if ( #enemies >= 2 ) and ( thisEntity:GetHealthPercent() < 30 ) then
		desire = #enemies + 1
	end
	
	return desire
end


function BehaviorRunAway:Begin()
	--print( "BehaviorRunAway:Begin()" )
	self.startEscapeTime = GameRules:GetGameTime()
	-- move towards our escape point
	return
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = self.escapePoint
	}

end

function BehaviorRunAway:IsDone( )
	return ( GameRules:GetGameTime() > ( self.startEscapeTime + 2 ) ) or
		( ( thisEntity:GetAbsOrigin() - self.escapePoint ):Length2D() < 200 )
end

function BehaviorRunAway:Think( )
	-- keep moving towards our escape point
	return
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = self.escapePoint
	}

end

--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorNone, BehaviorThunderClap, BehaviorRunAway }

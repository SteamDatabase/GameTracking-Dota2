--[[ Brewling Storm AI ]]

require( "ai/ai_core" )

function Spawn( entityKeyValues )
	thisEntity.bInitialized = false
	if not thisEntity.bInitialized then
		thisEntity.vInitialSpawnPos = thisEntity:GetOrigin()
		thisEntity.bInitialized = true
	end
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
    behaviorSystem = AICore:CreateBehaviorSystem( thisEntity, { BehaviorNone, BehaviorRunAway } )
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

AICore.possibleBehaviors = { BehaviorNone, BehaviorRunAway }

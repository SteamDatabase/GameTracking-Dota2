--[[
Gyrocopter AI
]]

require( "ai_core" )

behaviorSystem = {} -- create the global so we can assign to it

function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
	behaviorSystem = AICore:CreateBehaviorSystem( { BehaviorLaunchMissile, BehaviorRun } )
end

function AIThink()
	if thisEntity:IsNull() or not thisEntity:IsAlive() then
		return nil -- deactivate this think function
	end
	return behaviorSystem:Think()
end

--------------------------------------------------------------------------------------------------------

function CollectRetreatMarkers()
	local result = {}
	local i = 1
	local wp = nil
	while true do
		wp = Entities:FindByName( nil, string.format("waypoint_%d", i ) )
		if not wp then
			return result
		end
		local position = wp:GetOrigin()
		position.z = 0
		table.insert( result, position )
		i = i + 1
	end
end
POSITIONS_retreat = CollectRetreatMarkers()

BehaviorRun =
{
	order =
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = POSITIONS_retreat[ RandomInt(1, #POSITIONS_retreat) ],
	}
}

function BehaviorRun:Evaluate()
	return 1 -- must return a value > 0, so we have a default
end

function BehaviorRun:Initialize()
end

function BehaviorRun:Begin()
	self.endTime = GameRules:GetGameTime() + 1
end

function BehaviorRun:Continue()
	self.endTime = GameRules:GetGameTime() + 1
end

function BehaviorRun:Think(dt)
	local currentPos = thisEntity:GetOrigin()
	currentPos.z = 0

	if ( self.order.Position - currentPos ):Length() < 500 then
		self.order.Position = POSITIONS_retreat[ RandomInt(1, #POSITIONS_retreat) ]
	end
end

--------------------------------------------------------------------------------------------------------

BehaviorLaunchMissile = {}

function BehaviorLaunchMissile:Evaluate()
	self.ability = thisEntity:FindAbilityByName("holdout_gyrocopter_homing_missile")
	local target
	local desire = 0

	if self.ability and self.ability:IsFullyCastable() then
		local allEnemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
		if #allEnemies > 0 then
			target = allEnemies[RandomInt( 1, #allEnemies )]
		end
	end

	if target then
		desire = 5
		self.order =
		{
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			UnitIndex = thisEntity:entindex(),
			TargetIndex = target:entindex(),
			AbilityIndex = self.ability:entindex()
		}
	end

	return desire
end

function BehaviorLaunchMissile:Begin()
	self.endTime = GameRules:GetGameTime() + 5
end

BehaviorLaunchMissile.Continue = BehaviorLaunchMissile.Begin --if we re-enter this ability, we might have a different target; might as well do a full reset

function BehaviorLaunchMissile:Think(dt)
	if not self.ability:IsFullyCastable() and not self.ability:IsInAbilityPhase() then
		self.endTime = GameRules:GetGameTime()
	end
end

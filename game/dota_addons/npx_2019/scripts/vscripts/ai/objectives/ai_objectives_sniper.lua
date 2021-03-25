
local SNIPER_BOT_STATE_IDLE = 0
local SNIPER_BOT_STATE_ATTACK_ROSHAN = 1
local SNIPER_BOT_STATE_DEAD = 2

-----------------------------------------------------------------------------------------------------

if CObjectivesSniperBot == nil then
	CObjectivesSniperBot = class({})
end

-----------------------------------------------------------------------------------------------------

function CObjectivesSniperBot:constructor( me )
	self.me = me

	self.nBotState = SNIPER_BOT_STATE_IDLE
end

function CObjectivesSniperBot:BotThink()

	if self.nBotState == SNIPER_BOT_STATE_ATTACK_ROSHAN then

		if not self.me:IsAlive() then
			self.nBotState = SNIPER_BOT_STATE_DEAD
		end

		local fDistanceFromRoshan = ( self.me:GetAbsOrigin() - self.hRoshanSpawnLocation:GetAbsOrigin() ):Length2D()
		if fDistanceFromRoshan > 300 then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = self.hRoshanSpawnLocation:GetAbsOrigin()
			} )
		else
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
				TargetIndex = self.hRoshan:entindex()
			} )
		end

	end

end

function CObjectivesSniperBot:StartAttackingRoshan()
	if self.nBotState == SNIPER_BOT_STATE_IDLE then

		self.hRoshanSpawnLocation = Entities:FindByName( nil, "roshan_spawn_location" )
		self.hRoshan = Entities:FindByClassname( nil, "npc_dota_roshan" );

		self.nBotState = SNIPER_BOT_STATE_ATTACK_ROSHAN
	else
		print( "ERROR - trying to start capturing the outpost but not in the idle state" )
	end
end

function CObjectivesSniperBot:IsFinished()
	return self.nBotState == SNIPER_BOT_STATE_DEAD
end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "ObjectivesSniperThink", ObjectivesSniperThink, 0.1 )

		thisEntity.Bot = CObjectivesSniperBot( thisEntity )
	end
end


function ObjectivesSniperThink()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 0.1
end



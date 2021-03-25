
local BANE_BOT_STATE_IDLE = 0
local BANE_BOT_STATE_CAPTURE_OUTPOST = 1
local BANE_BOT_STATE_FINISHED = 2

-----------------------------------------------------------------------------------------------------

if CObjectivesBaneBot == nil then
	CObjectivesBaneBot = class({})
end

-----------------------------------------------------------------------------------------------------

function CObjectivesBaneBot:constructor( me )
	self.me = me

	self.hAbilityCapture = self.me:FindAbilityByName( "ability_capture" )
	self.hOutpost = Entities:FindByName( nil, "npc_dota_watch_tower_top" );

	self.nBotState = BANE_BOT_STATE_IDLE
	self.bCapturedOutpost = false
end

function CObjectivesBaneBot:BotThink()
	
	if self.nBotState == BANE_BOT_STATE_IDLE then
		
	elseif self.nBotState == BANE_BOT_STATE_CAPTURE_OUTPOST then

		if not self.me:IsAlive() then

			self.nBotState = BANE_BOT_STATE_FINISHED

		elseif self.hOutpost:GetTeamNumber() == self.me:GetTeamNumber() then
			
			self.bCapturedOutpost = true
			self.nBotState = BANE_BOT_STATE_FINISHED

		else

			local fDistanceFromOutpost = ( self.me:GetAbsOrigin() - self.hOutpost:GetAbsOrigin() ):Length2D()
			if fDistanceFromOutpost > self.hAbilityCapture:GetCastRange() then

				ExecuteOrderFromTable( {
					UnitIndex = self.me:entindex(),
					OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,
					TargetIndex = self.hOutpost:entindex()
				} )

			else
		
				if not self.hAbilityCapture:IsChanneling() then

					ExecuteOrderFromTable( {
						UnitIndex = self.me:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
						AbilityIndex = self.hAbilityCapture:entindex(),
						TargetIndex = self.hOutpost:entindex()
					} )
				end
			
			end
		end

	elseif self.nBotState == BANE_BOT_STATE_FINISHED then
		


	end

end

function CObjectivesBaneBot:StartCapturingOutpost()
	if self.nBotState == BANE_BOT_STATE_IDLE then
		self.nBotState = BANE_BOT_STATE_CAPTURE_OUTPOST
	else
		print( "ERROR - trying to start capturing the outpost but not in the idle state" )
	end
end

function CObjectivesBaneBot:IsFinished()
	return self.nBotState == BANE_BOT_STATE_FINISHED
end

function CObjectivesBaneBot:DidCaptureOutpost()
	return self.bCapturedOutpost
end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "ObjectivesBaneThink", ObjectivesBaneThink, 0.1 )

		thisEntity.Bot = CObjectivesBaneBot( thisEntity )
	end
end

function ObjectivesBaneThink()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 0.1
end




local DROW_RANGER_BOT_STATE_IDLE = 0
local DROW_RANGER_BOT_STATE_ATTACK_MOVE = 1

-----------------------------------------------------------------------------------------------------

if CLockdownScenarioDrowRangerBot == nil then
	CLockdownScenarioDrowRangerBot = class({})
end

--------------------------------------------------------------------------------

function CLockdownScenarioDrowRangerBot:constructor( me )
	self.me = me
	self.nBotState = DROW_RANGER_BOT_STATE_IDLE

	self.hAttackMoveLoc = Entities:FindByName( nil, "drow_attack_move_location" )
	ScriptAssert( self.hAttackMoveLoc ~= nil, "self.hAttackMoveLoc is nil!" )

	printf( "DrowRangerBot::constructor" )
end

--------------------------------------------------------------------------------

function CLockdownScenarioDrowRangerBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

--------------------------------------------------------------------------------

function CLockdownScenarioDrowRangerBot:BotThink()
	if not IsServer() then
		return
	end

	if self.bWasKilled then
		return -1
	end

	if ( not self.me:IsAlive() ) then
		self.bWasKilled = true
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	if self.nBotState == DROW_RANGER_BOT_STATE_IDLE then
		if GameRules.DotaNPX:IsTaskComplete( "moving_past_drow" ) then
			self:ChangeBotState( DROW_RANGER_BOT_STATE_ATTACK_MOVE )

			return 0.01
		end

		if self.fTimeSectionStarted == nil and GameRules.DotaNPX:IsTaskComplete( "move_to_drow_ranger" ) then
			self.fTimeSectionStarted = GameRules:GetGameTime()
		end

		if self.fTimeSectionStarted ~= nil then
			local fGracePeriodForPlayer = 3.0
			if ( GameRules:GetGameTime() > ( self.fTimeSectionStarted + fGracePeriodForPlayer ) ) then
				self:ChangeBotState( DROW_RANGER_BOT_STATE_ATTACK_MOVE )

				return 0.1
			end

			return 0.1
		end

		return 0.25
	elseif self.nBotState == DROW_RANGER_BOT_STATE_ATTACK_MOVE then
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			Position = self.hAttackMoveLoc:GetAbsOrigin(),
			Queue = true,
		} )

		return 0.5
	end

	return 0.5
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "LockdownScenarioDrowRangerThink", LockdownScenarioDrowRangerThink, 0.25 )

		thisEntity.Bot = CLockdownScenarioDrowRangerBot( thisEntity )
	end
end

--------------------------------------------------------------------------------

function LockdownScenarioDrowRangerThink()
	if IsServer() == false then
		return -1
	end

	return thisEntity.Bot:BotThink()
end

--------------------------------------------------------------------------------

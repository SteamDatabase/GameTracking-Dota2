
-- AI file for Part Two

local SNIPER_BOT_STATE_IDLE = 0
local SNIPER_BOT_STATE_ATTACK_MOVE = 1

-----------------------------------------------------------------------------------------------------

if CLockdownScenarioSniperPTBot == nil then
	CLockdownScenarioSniperPTBot = class({})
end

--------------------------------------------------------------------------------

function CLockdownScenarioSniperPTBot:constructor( me )
	self.me = me
	self.nBotState = SNIPER_BOT_STATE_IDLE

	self.hAttackMoveLoc = Entities:FindByName( nil, "p2_enemy_attack_move_loc" )
	ScriptAssert( self.hAttackMoveLoc ~= nil, "self.hAttackMoveLoc is nil!" )

	self.me:SetHealth( self.me:GetMaxHealth() * 0.8 )
end

--------------------------------------------------------------------------------

function CLockdownScenarioSniperPTBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

--------------------------------------------------------------------------------

function CLockdownScenarioSniperPTBot:BotThink()
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

	if not self.bInitialized then
		self.bInitialized = true

	 	local vDir = self.hAttackMoveLoc:GetAbsOrigin() - self.me:GetAbsOrigin()
	 	self.me:SetForwardVector( vDir )

	 	vDir = vDir:Normalized()
	 	local vMoveToPos = self.me:GetAbsOrigin() + ( vDir * 1 )

		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = vMoveToPos,
		} )
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	if self.nBotState == SNIPER_BOT_STATE_IDLE then
		--printf( "Sniper in state: SNIPER_BOT_STATE_IDLE" )

		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )

		if #Heroes >= 1 then
			self:ChangeBotState( SNIPER_BOT_STATE_ATTACK_MOVE )

			return 0.5
		end

		return 0.1
	elseif self.nBotState == SNIPER_BOT_STATE_ATTACK_MOVE then
		--printf( "Sniper in state: SNIPER_BOT_STATE_ATTACK_MOVE" )

		if not self.bAttackMoveCommandGiven then
			self.bAttackMoveCommandGiven = true

			--printf( "Sniper is moving to %s", self.hAttackMoveLoc:GetAbsOrigin() )
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = self.hAttackMoveLoc:GetAbsOrigin(),
			} )

			return 0.5
		end

		return 0.5
	end

	return 0.5
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "LockdownScenarioSniperPTThink", LockdownScenarioSniperPTThink, 0.25 )

		thisEntity.Bot = CLockdownScenarioSniperPTBot( thisEntity )
	end
end

--------------------------------------------------------------------------------

function LockdownScenarioSniperPTThink()
	if IsServer() == false then
		return -1
	end

	return thisEntity.Bot:BotThink()
end

--------------------------------------------------------------------------------


local SNIPER_BOT_STATE_IDLE = 0
local SNIPER_BOT_STATE_ATTACK_MOVE = 1
local SNIPER_BOT_STATE_ATTACK_HERO = 2
local SNIPER_BOT_STATE_ATTACK_TOWER = 3

-----------------------------------------------------------------------------------------------------

if CLockdownScenarioSniperBot == nil then
	CLockdownScenarioSniperBot = class({})
end

--------------------------------------------------------------------------------

function CLockdownScenarioSniperBot:constructor( me )
	self.me = me
	self.nBotState = SNIPER_BOT_STATE_IDLE

	self.hAttackMoveLoc = Entities:FindByName( nil, "sniper_attack_move_loc" )
	ScriptAssert( self.hAttackMoveLoc ~= nil, "self.hAttackMoveLoc is nil!" )

	self.me:SetHealth( self.me:GetMaxHealth() * 0.4 )
end

--------------------------------------------------------------------------------

function CLockdownScenarioSniperBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

--------------------------------------------------------------------------------

function CLockdownScenarioSniperBot:BotThink()
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

	if self.nBotState == SNIPER_BOT_STATE_IDLE then
		--printf( "Sniper in state: SNIPER_BOT_STATE_IDLE" )

		self:ChangeBotState( SNIPER_BOT_STATE_ATTACK_MOVE )

		return 0.5

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

		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )

		if #Heroes >= 1 then
			self:ChangeBotState( SNIPER_BOT_STATE_ATTACK_HERO )
		else
			self:ChangeBotState( SNIPER_BOT_STATE_ATTACK_TOWER )
		end

		return 0.5
	elseif self.nBotState == SNIPER_BOT_STATE_ATTACK_HERO then
		--printf( "Sniper in state: SNIPER_BOT_STATE_ATTACK_HERO" )
		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )

		if #Heroes >= 1 then
			local hTarget = Heroes[ 1 ]
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
				TargetIndex = hTarget:entindex(),
			} )

			return 1.0
		end

		if #Heroes == 0 then
			self:ChangeBotState( SNIPER_BOT_STATE_ATTACK_TOWER )
			return 0.5
		end

		return 0.5
	elseif self.nBotState == SNIPER_BOT_STATE_ATTACK_TOWER then
		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )

		-- @todo: attack tower?

		if #Heroes >= 1 then
			self:ChangeBotState( SNIPER_BOT_STATE_ATTACK_HERO )
			return 0.5
		end

		return 0.5
	end

	return 0.5
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "LockdownScenarioSniperThink", LockdownScenarioSniperThink, 0.25 )

		thisEntity.Bot = CLockdownScenarioSniperBot( thisEntity )
	end
end

--------------------------------------------------------------------------------

function LockdownScenarioSniperThink()
	if IsServer() == false then
		return -1
	end

	return thisEntity.Bot:BotThink()
end

--------------------------------------------------------------------------------

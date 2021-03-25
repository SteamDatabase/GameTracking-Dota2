
local ENIGMA_BOT_STATE_IDLE = 0
local ENIGMA_BOT_STATE_ATTACK_MOVE = 1
local ENIGMA_BOT_STATE_ATTACK_HERO = 2
local ENIGMA_BOT_STATE_ATTACK_TOWER = 3

-----------------------------------------------------------------------------------------------------

if CLockdownScenarioEnigmaBot == nil then
	CLockdownScenarioEnigmaBot = class({})
end

--------------------------------------------------------------------------------

function CLockdownScenarioEnigmaBot:constructor( me )
	self.me = me
	self.nBotState = ENIGMA_BOT_STATE_IDLE

	self.hBlackHoleAbility = self.me:FindAbilityByName( "enigma_black_hole" )	
	ScriptAssert( self.hBlackHoleAbility ~= nil, "self.hBlackHoleAbility is nil!" )

	self.hAttackMoveLoc = Entities:FindByName( nil, "enigma_attack_move_loc" )
	ScriptAssert( self.hAttackMoveLoc ~= nil, "self.hAttackMoveLoc is nil!" )

	self.me:SetHealth( self.me:GetMaxHealth() * 0.75 )
end

--------------------------------------------------------------------------------

function CLockdownScenarioEnigmaBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

--------------------------------------------------------------------------------

function CLockdownScenarioEnigmaBot:BotThink()
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

	if self.nBotState == ENIGMA_BOT_STATE_IDLE then
		--printf( "Enigma in state: ENIGMA_BOT_STATE_IDLE" )

		self:ChangeBotState( ENIGMA_BOT_STATE_ATTACK_MOVE )

		return 0.5
	elseif self.nBotState == ENIGMA_BOT_STATE_ATTACK_MOVE then
		--printf( "Enigma in state: ENIGMA_BOT_STATE_ATTACK_MOVE" )

		if not self.bAttackMoveCommandGiven then
			self.bAttackMoveCommandGiven = true

			--printf( "Enigma is moving to %s", self.hAttackMoveLoc:GetAbsOrigin() )
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = self.hAttackMoveLoc:GetAbsOrigin(),
			} )

			return 0.5
		end

		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )

		if #Heroes >= 1 then
			self:ChangeBotState( ENIGMA_BOT_STATE_ATTACK_HERO )
			return 0.5
		else
			self:ChangeBotState( ENIGMA_BOT_STATE_ATTACK_TOWER )
			return 0.5
		end

		return 0.5
	elseif self.nBotState == ENIGMA_BOT_STATE_ATTACK_HERO then
		--printf( "Enigma in state: ENIGMA_BOT_STATE_ATTACK_HERO" )

		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )

		if self.hBlackHoleAbility:IsCooldownReady() then
			if #Heroes >= 1 then
				local hNearTarget = Heroes[ 1 ]
				self.me:CastAbilityOnPosition( hNearTarget:GetAbsOrigin(), self.hBlackHoleAbility, -1 )

				return 0.5
			end
		end

		if #Heroes == 0 then
			self:ChangeBotState( ENIGMA_BOT_STATE_ATTACK_TOWER )
			return 0.5
		end

		return 0.5
	elseif self.nBotState == ENIGMA_BOT_STATE_ATTACK_TOWER then
		--printf( "Enigma in state: ENIGMA_BOT_STATE_ATTACK_TOWER" )

		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )

		if #Heroes >= 1 then
			self:ChangeBotState( ENIGMA_BOT_STATE_ATTACK_HERO )
			return 0.5
		end

		return 0.5
	end

	return 0.5
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "LockdownScenarioEnigmaThink", LockdownScenarioEnigmaThink, 0.25 )

		thisEntity.Bot = CLockdownScenarioEnigmaBot( thisEntity )
	end
end

--------------------------------------------------------------------------------

function LockdownScenarioEnigmaThink()
	if IsServer() == false then
		return -1
	end

	return thisEntity.Bot:BotThink()
end

--------------------------------------------------------------------------------

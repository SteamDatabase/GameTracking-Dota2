
local WRAITH_KING_BOT_STATE_IDLE = 0
local WRAITH_KING_BOT_STATE_ATTACK_MOVE = 1
local WRAITH_KING_BOT_STATE_ATTACK_HERO = 2
local WRAITH_KING_BOT_STATE_ATTACK_TOWER = 3

-----------------------------------------------------------------------------------------------------

if CLockdownScenarioWraithKingBot == nil then
	CLockdownScenarioWraithKingBot = class({})
end

--------------------------------------------------------------------------------

function CLockdownScenarioWraithKingBot:constructor( me )
	self.me = me
	self.nBotState = WRAITH_KING_BOT_STATE_IDLE

	self.hHellfireBlastAbility = self.me:FindAbilityByName( "skeleton_king_hellfire_blast" )	
	ScriptAssert( self.hHellfireBlastAbility ~= nil, "self.hHellfireBlastAbility is nil!" )

	self.hAttackMoveLoc = Entities:FindByName( nil, "wraith_king_attack_move_loc" )
	ScriptAssert( self.hAttackMoveLoc ~= nil, "self.hAttackMoveLoc is nil!" )

	self.me:SetHealth( self.me:GetMaxHealth() * 0.95 )
end

--------------------------------------------------------------------------------

function CLockdownScenarioWraithKingBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

--------------------------------------------------------------------------------

function CLockdownScenarioWraithKingBot:BotThink()
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

	if self.nBotState == WRAITH_KING_BOT_STATE_IDLE then
		--printf( "WraithKing in state: WRAITH_KING_BOT_STATE_IDLE" )

		self:ChangeBotState( WRAITH_KING_BOT_STATE_ATTACK_MOVE )

		return 0.5

	elseif self.nBotState == WRAITH_KING_BOT_STATE_ATTACK_MOVE then
		--printf( "WraithKing in state: WRAITH_KING_BOT_STATE_ATTACK_MOVE" )

		if not self.bAttackMoveCommandGiven then
			self.bAttackMoveCommandGiven = true

			--printf( "Wraith King is moving to %s", self.hAttackMoveLoc:GetAbsOrigin() )
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = self.hAttackMoveLoc:GetAbsOrigin(),
			} )

			return 0.5
		end

		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )

		if #Heroes >= 1 then
			self:ChangeBotState( WRAITH_KING_BOT_STATE_ATTACK_HERO )
		else
			self:ChangeBotState( WRAITH_KING_BOT_STATE_ATTACK_TOWER )
		end

		return 0.5
	elseif self.nBotState == WRAITH_KING_BOT_STATE_ATTACK_HERO then
		--printf( "WraithKing in state: WRAITH_KING_BOT_STATE_ATTACK_HERO" )

		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )

		if self.hHellfireBlastAbility:IsCooldownReady() then
			--printf( "Hellfire is ready" )
			if #Heroes >= 1 then
				local hNearTarget = Heroes[ 1 ]
				--printf( "Casting Hellfire Blast on %s", hNearTarget:GetUnitName() )
				self.me:CastAbilityOnTarget( hNearTarget, self.hHellfireBlastAbility, -1 )

				return 0.5
			end
		end

		if #Heroes == 0 then
			self:ChangeBotState( WRAITH_KING_BOT_STATE_ATTACK_TOWER )
			return 0.5
		end

		return 0.5
	elseif self.nBotState == WRAITH_KING_BOT_STATE_ATTACK_TOWER then
		--printf( "WraithKing in state: WRAITH_KING_BOT_STATE_ATTACK_TOWER" )

		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )

		if #Heroes >= 1 then
			self:ChangeBotState( WRAITH_KING_BOT_STATE_ATTACK_HERO )
			return 0.5
		end

		return 0.5
	end

	return 0.5
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "LockdownScenarioWraithKingThink", LockdownScenarioWraithKingThink, 0.25 )

		thisEntity.Bot = CLockdownScenarioWraithKingBot( thisEntity )
	end
end

--------------------------------------------------------------------------------

function LockdownScenarioWraithKingThink()
	if IsServer() == false then
		return -1
	end

	return thisEntity.Bot:BotThink()
end

--------------------------------------------------------------------------------

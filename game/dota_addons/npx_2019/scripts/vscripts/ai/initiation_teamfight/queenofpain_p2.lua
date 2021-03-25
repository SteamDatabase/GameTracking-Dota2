
local QUEENOFPAIN_BOT_STATE_IDLE = 0
local QUEENOFPAIN_BOT_STATE_ATTACK_MOVE = 1
local QUEENOFPAIN_BOT_STATE_UNLOAD_SPELLS = 2

-----------------------------------------------------------------------------------------------------

if CLockdownScenarioQueenOfPainPTBot == nil then
	CLockdownScenarioQueenOfPainPTBot = class({})
end

--------------------------------------------------------------------------------

function CLockdownScenarioQueenOfPainPTBot:constructor( me )
	self.me = me
	self.nBotState = QUEENOFPAIN_BOT_STATE_IDLE

	self.hSonicWaveAbility = self.me:FindAbilityByName( "queenofpain_sonic_wave" )	
	ScriptAssert( self.hSonicWaveAbility ~= nil, "self.hSonicWaveAbility is nil!" )

	self.hAttackMoveLoc = Entities:FindByName( nil, "p2_attack_move_loc" )
	ScriptAssert( self.hAttackMoveLoc ~= nil, "self.hAttackMoveLoc is nil!" )

	self.me:SetHealth( self.me:GetMaxHealth() * 0.4 )
end

--------------------------------------------------------------------------------

function CLockdownScenarioQueenOfPainPTBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

--------------------------------------------------------------------------------

function CLockdownScenarioQueenOfPainPTBot:BotThink()
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

	if self.nBotState == QUEENOFPAIN_BOT_STATE_IDLE then
		--printf( "QueenOfPain in state: QUEENOFPAIN_BOT_STATE_IDLE" )
		if GameRules.DotaNPX:IsTaskComplete( "move_to_p2_loc" ) then
			self:ChangeBotState( QUEENOFPAIN_BOT_STATE_ATTACK_MOVE )

			return 4.0
		end

		return 0.25
	elseif self.nBotState == QUEENOFPAIN_BOT_STATE_ATTACK_MOVE then
		printf( "QueenOfPainP2 in state: QUEENOFPAIN_BOT_STATE_ATTACK_MOVE" )
		if not self.bAttackMoveCommandGiven then
			self.bAttackMoveCommandGiven = true

			--printf( "QoP is moving to %s", self.hAttackMoveLoc:GetAbsOrigin() )
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = self.hAttackMoveLoc:GetAbsOrigin(),
			} )

			return 0.5
		end

		local Heroes = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, self.me:GetOrigin(), self.me, 1800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )

		local nStunnedEnemyHeroes = 0
		for _, hHero in pairs( Heroes ) do
			if hHero:IsStunned() then
				nStunnedEnemyHeroes = nStunnedEnemyHeroes + 1
			end
		end

		if nStunnedEnemyHeroes >= 3 then
			self:ChangeBotState( QUEENOFPAIN_BOT_STATE_UNLOAD_SPELLS )
		end

		return 0.5
	elseif self.nBotState == QUEENOFPAIN_BOT_STATE_UNLOAD_SPELLS then
		printf( "QueenOfPainP2 in state: QUEENOFPAIN_BOT_STATE_UNLOAD_SPELLS" )

		local Heroes = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, self.me:GetOrigin(), self.me, 1800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )

		if self.hSonicWaveAbility:IsCooldownReady() then
			--printf( "QueenOfPain: My sonic wave is ready" )
			if #Heroes >= 1 then
				--printf( "There's at least 1 enemy hero" )
				local hNearTarget = Heroes[ 1 ]
				--printf( "Casting %s on %s", self.hSonicWaveAbility:GetAbilityName(), hNearTarget:GetUnitName() )
				self.me:CastAbilityOnPosition( hNearTarget:GetAbsOrigin(), self.hSonicWaveAbility, -1 )

				return 1.0
			end
		else
			--printf( "QoP is moving to %s", self.hAttackMoveLoc:GetAbsOrigin() )
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
		thisEntity:SetContextThink( "LockdownScenarioQueenOfPainPTThink", LockdownScenarioQueenOfPainPTThink, 0.25 )

		thisEntity.Bot = CLockdownScenarioQueenOfPainPTBot( thisEntity )
	end
end

--------------------------------------------------------------------------------

function LockdownScenarioQueenOfPainPTThink()
	if IsServer() == false then
		return -1
	end

	return thisEntity.Bot:BotThink()
end

--------------------------------------------------------------------------------

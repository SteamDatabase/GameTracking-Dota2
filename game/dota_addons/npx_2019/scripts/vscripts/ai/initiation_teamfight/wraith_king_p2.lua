
-- AI file for Part Two

local WRAITH_KING_BOT_STATE_IDLE = 0
local WRAITH_KING_BOT_STATE_TEAMFIGHT = 1

-----------------------------------------------------------------------------------------------------

if CLockdownScenarioWraithKingPTBot == nil then
	CLockdownScenarioWraithKingPTBot = class({})
end

--------------------------------------------------------------------------------

function CLockdownScenarioWraithKingPTBot:constructor( me )
	self.me = me
	self.nBotState = WRAITH_KING_BOT_STATE_IDLE

	self.hAttackMoveLoc = Entities:FindByName( nil, "p2_enemy_attack_move_loc" )
	ScriptAssert( self.hAttackMoveLoc ~= nil, "self.hAttackMoveLoc is nil!" )

	self.hHellfireBlastAbility = self.me:FindAbilityByName( "skeleton_king_hellfire_blast" )	
	ScriptAssert( self.hHellfireBlastAbility ~= nil, "self.hHellfireBlastAbility is nil!" )

	self.me:SetHealth( self.me:GetMaxHealth() * 0.8 )

	self.nFlags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE
end

--------------------------------------------------------------------------------

function CLockdownScenarioWraithKingPTBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

--------------------------------------------------------------------------------

function CLockdownScenarioWraithKingPTBot:BotThink()
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

	if self.nBotState == WRAITH_KING_BOT_STATE_IDLE then
		--printf( "WraithKing in state: WRAITH_KING_BOT_STATE_IDLE" )

		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, self.nFlags, 0, false )

		if #Heroes >= 1 then
			self:ChangeBotState( WRAITH_KING_BOT_STATE_TEAMFIGHT )

			return 0.5
		end

		return 0.1
	elseif self.nBotState == WRAITH_KING_BOT_STATE_TEAMFIGHT then
		--printf( "WraithKing in state: WRAITH_KING_BOT_STATE_TEAMFIGHT" )
		self.nFlags = DOTA_UNIT_TARGET_FLAG_NONE

		local nCastRange = self.hHellfireBlastAbility:GetCastRange( self.me:GetOrigin(), nil )
		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, nCastRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, self.nFlags, 0, false )

		if self.hHellfireBlastAbility:IsCooldownReady() and #Heroes >= 1 then
			local hNearTarget = Heroes[ 1 ]
			--printf( "Casting Hellfire Blast on %s", hNearTarget:GetUnitName() )
			self.me:CastAbilityOnTarget( hNearTarget, self.hHellfireBlastAbility, -1 )

			return 1.0
		end

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

		return 0.5
	end

	return 0.5
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "LockdownScenarioWraithKingPTThink", LockdownScenarioWraithKingPTThink, 0.25 )

		thisEntity.Bot = CLockdownScenarioWraithKingPTBot( thisEntity )
	end
end

--------------------------------------------------------------------------------

function LockdownScenarioWraithKingPTThink()
	if IsServer() == false then
		return -1
	end

	return thisEntity.Bot:BotThink()
end

--------------------------------------------------------------------------------

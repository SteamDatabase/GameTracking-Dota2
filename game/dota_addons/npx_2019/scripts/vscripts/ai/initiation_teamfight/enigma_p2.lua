
-- AI file for Part Two

local ENIGMA_BOT_STATE_IDLE = 0
local ENIGMA_BOT_STATE_ATTACK_MOVE = 1
local ENIGMA_BOT_STATE_TEAMFIGHT = 2

-----------------------------------------------------------------------------------------------------

if CLockdownScenarioEnigmaPTBot == nil then
	CLockdownScenarioEnigmaPTBot = class({})
end

--------------------------------------------------------------------------------

function CLockdownScenarioEnigmaPTBot:constructor( me )
	self.me = me
	self.nBotState = ENIGMA_BOT_STATE_IDLE

	self.hBlackHoleAbility = self.me:FindAbilityByName( "enigma_black_hole" )	
	ScriptAssert( self.hBlackHoleAbility ~= nil, "self.hBlackHoleAbility is nil!" )

	self.hAttackMoveLoc = Entities:FindByName( nil, "p2_enemy_attack_move_loc" )
	ScriptAssert( self.hAttackMoveLoc ~= nil, "self.hAttackMoveLoc is nil!" )

	self.me:SetHealth( self.me:GetMaxHealth() * 0.45 )

	self.nFlags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE
end

--------------------------------------------------------------------------------

function CLockdownScenarioEnigmaPTBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

--------------------------------------------------------------------------------

function CLockdownScenarioEnigmaPTBot:BotThink()
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

		self.hBlackKingBar = FindItemByName( self.me, "item_black_king_bar" )
		ScriptAssert( self.hBlackKingBar ~= nil, "self.hBlackKingBar is nil!" )

		self.hBlink = FindItemByName( self.me, "item_blink" )
		ScriptAssert( self.hBlink ~= nil, "self.hBlink is nil!" )

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

	if self.me:IsChanneling() then
		--printf( "Enigma is busy channeling, return to think shortly" )
		return 0.1
	end

	if self.nBotState == ENIGMA_BOT_STATE_IDLE then
		--printf( "Enigma in state: ENIGMA_BOT_STATE_IDLE" )

		local bEarlyTriggerActivated = GameRules.DotaNPX.CurrentScenario.bPartTwoEarlyTriggerActivated
		if bEarlyTriggerActivated then
			printf( "Enigma entering TEAMFIGHT state early at %.2f due to trigger activation", GameRules:GetGameTime() )
			self:ChangeBotState( ENIGMA_BOT_STATE_TEAMFIGHT )

			return 0.1
		end

		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, self.nFlags, 0, false )

		if #Heroes >= 1 then
			self:ChangeBotState( ENIGMA_BOT_STATE_TEAMFIGHT )

			printf( "Enigma entering TEAMFIGHT state at %.2f because he saw an enemy hero", GameRules:GetGameTime() )

			return 1.5
		end

		return 0.01
	elseif self.nBotState == ENIGMA_BOT_STATE_TEAMFIGHT then
		--printf( "Enigma in state ENIGMA_BOT_STATE_TEAMFIGHT at %.2f", GameRules:GetGameTime() )
		self.nFlags = DOTA_UNIT_TARGET_FLAG_NONE

		if not self.bFirstAttackMoveCommandGiven then
			self.bFirstAttackMoveCommandGiven = true

			--printf( "Enigma is moving to %s", self.hAttackMoveLoc:GetAbsOrigin() )
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = self.hAttackMoveLoc:GetAbsOrigin(),
			} )

			return 0.01
		end

		if not self.me:IsStunned() and self.hBlackKingBar:IsFullyCastable() then
			self.me:CastAbilityNoTarget( self.hBlackKingBar, -1 )

			return 0.2
		end

		local nBlinkRange = 1200
		local HeroesInBlinkRange = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, nBlinkRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, self.nFlags, 0, false )

		if #HeroesInBlinkRange >= 1 then
			if self.hBlink:IsCooldownReady() then
				local hBlinkTarget = nil

				-- Prioritize Tidehunter
				for _, hero in pairs( HeroesInBlinkRange ) do
					if hero and hero:GetUnitName() == "npc_dota_hero_tidehunter" then
						hBlinkTarget = hero
					end
				end

				if hBlinkTarget == nil then
					hBlinkTarget = HeroesInBlinkRange[ 1 ]
				end

				local vToTarget = hBlinkTarget:GetAbsOrigin() - self.me:GetAbsOrigin()
				vToTarget = vToTarget:Normalized()
				local vBlinkPos = hBlinkTarget:GetAbsOrigin() - ( vToTarget * 150 )
				printf( "Casting %s on position %s", self.hBlink:GetAbilityName(), vBlinkPos )
				self.me:CastAbilityOnPosition( hBlinkTarget:GetAbsOrigin(), self.hBlink, -1 )

				return 0.2
			end
		end

		local nBlackHoleRange = self.hBlackHoleAbility:GetCastRange( self.me:GetAbsOrigin(), nil )
		local HeroesInBlackHoleRange = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, nBlackHoleRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, self.nFlags, 0, false )

		if #HeroesInBlackHoleRange >= 1 then
			if self.hBlackHoleAbility:IsCooldownReady() then
				local hBlackHoleTarget = nil

				-- Prioritize Tidehunter
				for _, hero in pairs( HeroesInBlackHoleRange ) do
					if hero and hero:GetUnitName() == "npc_dota_hero_tidehunter" then
						hBlackHoleTarget = hero
					end
				end

				if hBlackHoleTarget == nil then
					hBlackHoleTarget = HeroesInBlackHoleRange[ 1 ]
				end

				local vFromTarget = self.me:GetAbsOrigin() - hBlackHoleTarget:GetAbsOrigin()
				local fLengthToTarget = vFromTarget:Length2D()
				local nDistanceInward = 0
				if fLengthToTarget > 150 then
					nDistanceInward = 100
				end

				vFromTarget = vFromTarget:Normalized()
				local vBlackHolePos = hBlackHoleTarget:GetAbsOrigin() + ( vFromTarget * nDistanceInward )
				printf( "Casting %s on position %s", self.hBlackHoleAbility:GetAbilityName(), vBlackHolePos )
				self.me:CastAbilityOnPosition( vBlackHolePos, self.hBlackHoleAbility, -1 )

				return 0.5
			end
		end

		if not self.bAttackMoveCommandGiven then
			self.bAttackMoveCommandGiven = true

			--printf( "Enigma is moving to %s", self.hAttackMoveLoc:GetAbsOrigin() )
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = self.hAttackMoveLoc:GetAbsOrigin(),
			} )

			return 0.01
		end

		return 0.01
	end

	return 0.5
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "LockdownScenarioEnigmaPTThink", LockdownScenarioEnigmaPTThink, 0.25 )

		thisEntity.Bot = CLockdownScenarioEnigmaPTBot( thisEntity )
	end
end

--------------------------------------------------------------------------------

function LockdownScenarioEnigmaPTThink()
	if IsServer() == false then
		return -1
	end

	return thisEntity.Bot:BotThink()
end

--------------------------------------------------------------------------------

function FindItemByName( hUnit, strItemName )
	for iSlot = DOTA_ITEM_SLOT_1, DOTA_ITEM_MAX do
		local hItem = hUnit:GetItemInSlot( iSlot )
		if hItem and hItem:GetAbilityName() == strItemName then
			return hItem
		end
	end
end

--------------------------------------------------------------------------------

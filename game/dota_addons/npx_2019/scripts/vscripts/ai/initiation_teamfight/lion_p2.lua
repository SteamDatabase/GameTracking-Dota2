
local LION_BOT_STATE_IDLE = 0
local LION_BOT_STATE_BLINK = 1
local LION_BOT_STATE_UNLOAD_SPELLS = 2

-----------------------------------------------------------------------------------------------------

if CLockdownScenarioLionPTBot == nil then
	CLockdownScenarioLionPTBot = class({})
end

--------------------------------------------------------------------------------

function CLockdownScenarioLionPTBot:constructor( me )
	self.me = me
	self.nBotState = LION_BOT_STATE_IDLE

	self.hFingerAbility = self.me:FindAbilityByName( "lion_finger_of_death" )	
	ScriptAssert( self.hFingerAbility ~= nil, "self.hFingerAbility is nil!" )

	self.hImpaleAbility = self.me:FindAbilityByName( "lion_impale" )	
	ScriptAssert( self.hImpaleAbility ~= nil, "self.hImpaleAbility is nil!" )

	self.hAttackMoveLoc = Entities:FindByName( nil, "p2_attack_move_loc" )
	ScriptAssert( self.hAttackMoveLoc ~= nil, "self.hAttackMoveLoc is nil!" )

	self.me:SetHealth( self.me:GetMaxHealth() * 0.8 )
end

--------------------------------------------------------------------------------

function CLockdownScenarioLionPTBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

--------------------------------------------------------------------------------

function CLockdownScenarioLionPTBot:BotThink()
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

	if self.nBotState == LION_BOT_STATE_IDLE then
		--printf( "Lion in state: LION_BOT_STATE_IDLE" )
		local Heroes = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, self.me:GetOrigin(), self.me, 1800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )

		local nStunnedEnemyHeroes = 0
		for _, hHero in pairs( Heroes ) do
			if hHero:IsStunned() then
				nStunnedEnemyHeroes = nStunnedEnemyHeroes + 1
			end
		end

		if nStunnedEnemyHeroes >= 3 then
			self:ChangeBotState( LION_BOT_STATE_BLINK )

			return 0.2
		end

		if self.fTimeTeamfightStarted == nil and GameRules.DotaNPX:IsTaskComplete( "enter_second_teamfight_trigger" ) then
			self.fTimeTeamfightStarted = GameRules:GetGameTime()

			return 0.1
		end

		if self.fTimeTeamfightStarted ~= nil then
			local fGracePeriodForPlayer = 1.5
			if ( GameRules:GetGameTime() > ( self.fTimeTeamfightStarted + fGracePeriodForPlayer ) ) then
				-- Lion is slow if player has done wrong thing
				self:ChangeBotState( LION_BOT_STATE_BLINK )

				return 0.2
			end

			return 0.25
		end

		return 0.25
	elseif self.nBotState == LION_BOT_STATE_BLINK then
		--printf( "LionP2 in state: LION_BOT_STATE_BLINK" )
		if self.hBlink:IsCooldownReady() then
			--printf( "Casting %s", self.hBlink:GetAbilityName() )
			local hTidehunters = Entities:FindAllByName( "npc_dota_hero_tidehunter" )
			if hTidehunters ~= nil then
				local vBlinkPos = hTidehunters[ 1 ]:GetAbsOrigin()
				vBlinkPos = vBlinkPos + RandomVector( RandomFloat( 100, 200 ) )
				self.me:CastAbilityOnPosition( vBlinkPos, self.hBlink, -1 )

				self:ChangeBotState( LION_BOT_STATE_UNLOAD_SPELLS )

				return 0.25
			end
		end

		return 0.5
	elseif self.nBotState == LION_BOT_STATE_UNLOAD_SPELLS then
		--printf( "LionP2 in state: LION_BOT_STATE_UNLOAD_SPELLS" )

		local Heroes = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, self.me:GetOrigin(), self.me, 1800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )

		-- Iterate over enemy heroes, if there's one with BKB who isn't currently magic immune, prioritize it

		if #Heroes >= 1 then
			local hTarget = nil
			for _, hero in pairs( Heroes) do
				local hBlackKingBar = FindItemByName( hero, "item_black_king_bar" )
				if hBlackKingBar and hero:IsMagicImmune() == false then
					hTarget = hero
					break
				end
			end

			if hTarget == nil then
				hTarget = Heroes[ 1 ]
			end

			if self.hFingerAbility:IsCooldownReady() then
				--printf( "Casting %s on %s", self.hCallDownAbility:GetAbilityName(), hNearTarget:GetUnitName() )
				self.me:CastAbilityOnTarget( hTarget, self.hFingerAbility, -1 )

				return 0.5
			elseif self.hImpaleAbility:IsCooldownReady() then
				self.me:CastAbilityOnTarget( hTarget, self.hImpaleAbility, -1 )

				return 0.5
			end
		end

		if not self.bAttackMoveCommandGiven then
			self.bAttackMoveCommandGiven = true

			--printf( "Lion is moving to %s", self.hAttackMoveLoc:GetAbsOrigin() )
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
		thisEntity:SetContextThink( "LockdownScenarioLionPTThink", LockdownScenarioLionPTThink, 0.25 )

		thisEntity.Bot = CLockdownScenarioLionPTBot( thisEntity )
	end
end

--------------------------------------------------------------------------------

function LockdownScenarioLionPTThink()
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

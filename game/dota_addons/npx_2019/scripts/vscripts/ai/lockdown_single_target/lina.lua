
local LINA_BOT_STATE_IDLE = 0
local LINA_BOT_STATE_MOVE = 1
local LINA_BOT_STATE_TELEPORT_OUT = 2

-----------------------------------------------------------------------------------------------------

if CLockdownScenarioLinaBot == nil then
	CLockdownScenarioLinaBot = class({})
end

--------------------------------------------------------------------------------

function CLockdownScenarioLinaBot:constructor( me )
	self.me = me
	self.nBotState = LINA_BOT_STATE_IDLE

	self.hMoveLoc = Entities:FindByName( nil, "lina_move_location" )
	ScriptAssert( self.hMoveLoc ~= nil, "self.hMoveLoc is nil!" )

	self.hTeleportHomeLoc = Entities:FindByName( nil, "teleport_home_loc" )
	ScriptAssert( self.hTeleportHomeLoc ~= nil, "self.hTeleportHomeLoc is nil!" )

	self.me:AddNewModifier( self.me, nil, "modifier_disable_healing", { duration = -1 } )

	printf( "LinaBot::constructor" )
end

--------------------------------------------------------------------------------

function CLockdownScenarioLinaBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

--------------------------------------------------------------------------------

function CLockdownScenarioLinaBot:BotThink()
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
		self.hTpScroll = FindItemByName( self.me, "item_tpscroll" )
		ScriptAssert( self.hTpScroll ~= nil, "self.hTpScroll is nil!" )

		RefreshHero( self.me ) -- forcing tp scrolls to not have early game cd
		self.me:SetHealth( self.me:GetMaxHealth() * 0.45 )
	end

	if GameRules:IsGamePaused() == true then
		return 0.01
	end

	if self.nBotState == LINA_BOT_STATE_IDLE then
		if GameRules.DotaNPX:IsTaskComplete( "moving_past_lina_trigger" ) then
			self:ChangeBotState( LINA_BOT_STATE_MOVE )

			return 0.01
		end

		if self.fTimeSectionStarted == nil and GameRules.DotaNPX:IsTaskComplete( "move_to_lina" ) then
			self.fTimeSectionStarted = GameRules:GetGameTime()
		end

		if self.fTimeSectionStarted ~= nil then
			local fGracePeriodForPlayer = 3.0
			if ( GameRules:GetGameTime() > ( self.fTimeSectionStarted + fGracePeriodForPlayer ) ) then
				self:ChangeBotState( LINA_BOT_STATE_MOVE )

				return 0.1
			end

			return 0.1
		end


		return 0.01
	elseif self.nBotState == LINA_BOT_STATE_MOVE then
		if not self.bAttackMoveCommandGiven then
			self.bAttackMoveCommandGiven = true

			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = self.hMoveLoc:GetAbsOrigin(),
				Queue = true,
			} )

			self.fMovementStarted = GameRules:GetGameTime()
		end

		-- Waiting for enemy's stun on me before entering teleport-out state
		if self.me:IsStunned() and self.hTpScroll and self.hTpScroll:IsFullyCastable() then
			printf( "  LINA_BOT_STATE_TELEPORT_OUT: Lina is not stunned and has a tp scroll ability ready to cast" )

			self:ChangeBotState( LINA_BOT_STATE_TELEPORT_OUT )

			return 0.01
		end

		-- If enough time has passed, just TP out, because we can miss the stun period in between our thinks if the stun is extremely short
		if self.fMovementStarted ~= nil and ( GameRules:GetGameTime() > ( self.fMovementStarted + 2.0 ) ) then
			self:ChangeBotState( LINA_BOT_STATE_TELEPORT_OUT )

			return 0.01
		end

		return 0.01
	elseif self.nBotState == LINA_BOT_STATE_TELEPORT_OUT then
		--printf( "Lina in state: LINA_BOT_STATE_TELEPORT_OUT" )

		if self.me:IsStunned() then
			--printf( "  Lina is stunned, return early" )
			return 0.02
		end

		if self.hTpScroll == nil or self.hTpScroll:IsFullyCastable() == false then
			--printf( "  Lina's tp scroll is nil or isn't ready, return early" )
			return 0.02
		end

		if ( not self.bWantsToTeleport ) then
			self.bWantsToTeleport = true
			--printf( "bWantsToTeleport == %s", tostring( self.bWantsToTeleport ) )

			return 0.55 -- controls how quickly Lina starts tp after stun ends
		elseif self.bWantsToTeleport then
			ExecuteOrderFromTable({
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_STOP
			})

			local vTeleportPos = self.hTeleportHomeLoc:GetAbsOrigin()
			--printf( "  Cast teleport on %s", vTeleportPos )
			self.me:CastAbilityOnPosition( vTeleportPos, self.hTpScroll, -1 )

			return 4.0
		end

		return 0.02
	end

	return 0.5
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "LockdownScenarioLinaThink", LockdownScenarioLinaThink, 0.25 )

		thisEntity.Bot = CLockdownScenarioLinaBot( thisEntity )
	end
end

--------------------------------------------------------------------------------

function LockdownScenarioLinaThink()
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

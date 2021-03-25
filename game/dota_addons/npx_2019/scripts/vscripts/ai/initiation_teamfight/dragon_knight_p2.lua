
local DRAGON_KNIGHT_BOT_STATE_IDLE = 0
local DRAGON_KNIGHT_BOT_STATE_TEAMFIGHT = 1

-----------------------------------------------------------------------------------------------------

if CLockdownScenarioDragonKnightBot == nil then
	CLockdownScenarioDragonKnightBot = class({})
end

--------------------------------------------------------------------------------

function CLockdownScenarioDragonKnightBot:constructor( me )
	self.me = me
	self.nBotState = DRAGON_KNIGHT_BOT_STATE_IDLE

	self.hDragonFormAbility = self.me:FindAbilityByName( "dragon_knight_elder_dragon_form" )	
	ScriptAssert( self.hDragonFormAbility ~= nil, "self.hDragonFormAbility is nil!" )

	self.hAttackMoveLoc = Entities:FindByName( nil, "p2_attack_move_loc" )
	ScriptAssert( self.hAttackMoveLoc ~= nil, "self.hAttackMoveLoc is nil!" )

	--self.me:SetHealth( self.me:GetMaxHealth() * 0.5 )
end

--------------------------------------------------------------------------------

function CLockdownScenarioDragonKnightBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

--------------------------------------------------------------------------------

function CLockdownScenarioDragonKnightBot:BotThink()
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

	if self.nBotState == DRAGON_KNIGHT_BOT_STATE_IDLE then
		--printf( "Dragon Knight in state: DRAGON_KNIGHT_BOT_STATE_IDLE" )
		if GameRules.DotaNPX:IsTaskComplete( "enter_second_teamfight_trigger" ) == true then
			self:ChangeBotState( DRAGON_KNIGHT_BOT_STATE_TEAMFIGHT )

			return 0.01
		end

		return 0.25
	elseif self.nBotState == DRAGON_KNIGHT_BOT_STATE_TEAMFIGHT then
		--printf( "Dragon Knight in state: DRAGON_KNIGHT_BOT_STATE_TEAMFIGHT" )

		if self.hDragonFormAbility:IsFullyCastable() then
			self.me:CastAbilityNoTarget( self.hDragonFormAbility, -1 )

			return 0.25
		end

		if not self.bAttackMoveCommandGiven then
			self.bAttackMoveCommandGiven = true

			--printf( "Dragon Knight is moving to %s", self.hAttackMoveLoc:GetAbsOrigin() )
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
		thisEntity:SetContextThink( "LockdownScenarioDragonKnightThink", LockdownScenarioDragonKnightThink, 0.25 )

		thisEntity.Bot = CLockdownScenarioDragonKnightBot( thisEntity )
	end
end

--------------------------------------------------------------------------------

function LockdownScenarioDragonKnightThink()
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

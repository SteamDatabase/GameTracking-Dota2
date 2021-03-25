
local INVOKER_BOT_STATE_INTRO					= 1
local INVOKER_BOT_STATE_IDLE					= 2

-----------------------------------------------------------------------------------------------------

if CGlimmerCapeInvokerBot == nil then
	CGlimmerCapeInvokerBot = class({})
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeInvokerBot:constructor( me )
	self.me = me
	self.nBotState = INVOKER_BOT_STATE_INTRO
	self.hAttackTarget = nil
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeInvokerBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeInvokerBot:BotThink()

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
	
	if self.nBotState == INVOKER_BOT_STATE_INTRO then
		self:GoToDestination()

	elseif self.nBotState == INVOKER_BOT_STATE_IDLE then

	end
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeInvokerBot:GoToDestination()
	local hMovePosition = Entities:FindByName( nil, "invoker_move_pos" )
	if hMovePosition ~= nil then

		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = hMovePosition:GetAbsOrigin(),
			Queue = false,
		} )

		self:ChangeBotState( INVOKER_BOT_STATE_IDLE )
	end
end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "InvokerThink", InvokerThink, 0.25 )
		thisEntity.Bot = CGlimmerCapeInvokerBot( thisEntity )
	end
end

-----------------------------------------------------------------------------------------------------

function InvokerThink()
	if IsServer() == false then
		return -1
	end

	local fThinkTime = thisEntity.Bot:BotThink()
	if fThinkTime then
		return fThinkTime
	end

	return 0.1
end

-----------------------------------------------------------------------------------------------------

function FindItemByName( hUnit, strItemName )
	for iSlot = DOTA_ITEM_SLOT_1,DOTA_ITEM_MAX do
		local hItem = hUnit:GetItemInSlot( iSlot )
		if hItem and hItem:GetAbilityName() == strItemName then
			return hItem
		end
	end
end

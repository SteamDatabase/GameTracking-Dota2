
local OGRE_BOT_STATE_IDLE					= 1
local OGRE_BOT_STATE_CHECK_FOR_ARRIVAL		= 2
local OGRE_BOT_STATE_TP_OUT					= 3

-----------------------------------------------------------------------------------------------------

if CGlimmerCapeOgreBot == nil then
	CGlimmerCapeOgreBot = class({})
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeOgreBot:constructor( me )
	self.me = me
	self.nBotState = OGRE_BOT_STATE_IDLE
	self.hAttackTarget = nil

	self.hTpPosition = Entities:FindByName( nil, "ogre_tp_pos" )
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeOgreBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeOgreBot:TpOut()
	self:ChangeBotState( OGRE_BOT_STATE_TP_OUT )
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeOgreBot:BotThink()

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

	if self.hTpScroll == nil then
		self.hTpScroll = self.me:GetItemInSlot( DOTA_ITEM_TP_SCROLL )
		if self.hTpScroll then
			self.hTpScroll:EndCooldown()
		end
	end

	if self.nBotState == OGRE_BOT_STATE_IDLE then

	elseif self.nBotState == OGRE_BOT_STATE_CHECK_FOR_ARRIVAL then

		-- succeed if ogre makes it to his destination
		local hMovePosition = Entities:FindByName( nil, "ogre_move_pos" )
		if hMovePosition ~= nil then
			local fDistanceToGoal = ( self.me:GetAbsOrigin() - hMovePosition:GetAbsOrigin() ):Length2D()
			if fDistanceToGoal < 150 then
				local hTask = GameRules.DotaNPX:GetTask( "protect_ogre" )
				if hTask ~= nil and hTask:IsCompleted() == false then
					hTask:CompleteTask( true )
				end
			end
		end

	elseif self.nBotState == OGRE_BOT_STATE_TP_OUT then
		if self.hTpScroll and self.hTpScroll:IsNull() == false then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self.hTpScroll:entindex(),
				Position = self.hTpPosition:GetAbsOrigin(),
			} )
			
			if not self.hTpScroll:IsFullyCastable() and not self.hTpScroll:IsChanneling() then
				self.me:ForceKill( false )
				--self:ChangeBotState( CHAOS_KNIGHT_BOT_STATE_IDLE )
			end
		end

	end
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeOgreBot:GoToDestination()
	local hMovePosition = Entities:FindByName( nil, "ogre_move_pos" )
	if hMovePosition ~= nil then

		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = hMovePosition:GetAbsOrigin(),
			Queue = false,
		} )

		self:ChangeBotState( OGRE_BOT_STATE_CHECK_FOR_ARRIVAL )
	end
end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "OgreThink", OgreThink, 0.25 )
		thisEntity.Bot = CGlimmerCapeOgreBot( thisEntity )
	end
end

-----------------------------------------------------------------------------------------------------

function OgreThink()
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

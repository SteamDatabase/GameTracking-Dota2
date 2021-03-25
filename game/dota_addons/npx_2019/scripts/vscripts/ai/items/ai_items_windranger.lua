
local WINDRANGER_BOT_STATE_IDLE = 0
local WINDRANGER_BOT_STATE_ATTACK_MOVE = 1

-----------------------------------------------------------------------------------------------------

if CItemsScenarioWindrangerBot == nil then
	CItemsScenarioWindrangerBot = class({})
end

--------------------------------------------------------------------------------

function CItemsScenarioWindrangerBot:constructor( me )
	self.me = me
	self.nBotState = WINDRANGER_BOT_STATE_IDLE
	self.bMovedToStart = false
	self.bReceivedTango = false
	self.hInitialMoveLoc = Entities:FindByName( nil, "teammate_2_spawner" )
	self.hMidLaneMoveLoc = Entities:FindByName( nil, "mid_lane_location" )

	printf( "WindrangerBot::constructor" )
end

--------------------------------------------------------------------------------

function CItemsScenarioWindrangerBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

--------------------------------------------------------------------------------

function CItemsScenarioWindrangerBot:BotThink()
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

	if self.me:FindItemInInventory( "item_tango_single" ) then
		self.bReceivedTango = true
	end

	if self.bReceivedTango == false then
		if self.bMovedToStart == false then
			self:MoveToLocation( self.hInitialMoveLoc )
			self.bMovedToStart = true
		end
	else
		self:MoveToLocation( self.hMidLaneMoveLoc )
	end

	return 0.5
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "WindrangerThink", WindrangerThink, 0.25 )

		thisEntity.Bot = CItemsScenarioWindrangerBot( thisEntity )
	end
end

--------------------------------------------------------------------------------

function WindrangerThink()
	if IsServer() == false then
		return -1
	end

	return thisEntity.Bot:BotThink()
end

--------------------------------------------------------------------------------

function CItemsScenarioWindrangerBot:MoveToLocation( hMoveLoc )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = hMoveLoc:GetAbsOrigin(),
		Queue = true,
	} )
end

--------------------------------------------------------------------------------


local LICH_BOT_STATE_INTRO					= 0
local LICH_BOT_STATE_IDLE					= 1
local LICH_BOT_STATE_ENTER_PIT				= 2
local LICH_BOT_STATE_ATTACK					= 3
local LICH_BOT_STATE_FROST_BLAST			= 4
local LICH_BOT_STATE_TP_OUT					= 5

-----------------------------------------------------------------------------------------------------

if CRoshanLichBot == nil then
	CRoshanLichBot = class({})
end

-----------------------------------------------------------------------------------------------------

function CRoshanLichBot:constructor( me )
	self.me = me
	self.hAbilityFrostBlast = self.me:FindAbilityByName( "lich_frost_nova" )
	self.nBotState = LICH_BOT_STATE_INTRO
	self.hAttackTarget = nil

	self.hStartPosition = Entities:FindByName( nil, "lich_start_pos" )
	self.hPitPosition = Entities:FindByName( nil, "lich_pit_pos" )
	self.hTpPosition = Entities:FindByName( nil, "lich_tp_pos" )

	self.bMoveToPit = false
	self.bTpOut = false
end

-----------------------------------------------------------------------------------------------------

function CRoshanLichBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

-----------------------------------------------------------------------------------------------------

function CRoshanLichBot:SetMoveToPit( bMoveToPit )
	self.bMoveToPit = bMoveToPit
end

-----------------------------------------------------------------------------------------------------

function CRoshanLichBot:SetTpOut( bTpOut )
	self.bTpOut = bTpOut
end

-----------------------------------------------------------------------------------------------------

function CRoshanLichBot:BotThink()

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

	if self.nBotState == LICH_BOT_STATE_INTRO then
		if self.bMoveToPit == true then
			if self.hPitPosition ~= nil then

				ExecuteOrderFromTable( {
					UnitIndex = self.me:entindex(),
					OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
					Position = self.hPitPosition:GetAbsOrigin(),
					Queue = false,
				} )

				self:ChangeBotState( LICH_BOT_STATE_ENTER_PIT )
			end
		end

	elseif self.nBotState == LICH_BOT_STATE_ENTER_PIT then

		-- switch to roshan battle mode once we're close enough
		if self.hPitPosition ~= nil then
			local fDistanceToGoal = ( self.me:GetAbsOrigin() - self.hPitPosition:GetAbsOrigin() ):Length2D()
			if fDistanceToGoal < 200 then
				print( 'LICH BOT - in the pit! switching to IDLE' )
				self:ChangeBotState( LICH_BOT_STATE_IDLE )
			end
		end

	elseif self.nBotState == LICH_BOT_STATE_IDLE then

		if self.bTpOut == true then
			self:ChangeBotState( LICH_BOT_STATE_TP_OUT )
			return
		end

		local hUnits = FindUnitsInRadius( self.me:GetTeamNumber(), self.me:GetOrigin(), self.me, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
		if #hUnits > 0 then
			self.hAttackTarget = hUnits[1]
			self:ChangeBotState( LICH_BOT_STATE_ATTACK )
		end
	
	elseif self.nBotState == LICH_BOT_STATE_ATTACK then
		
		if not self.hAttackTarget:IsAlive() then
			self:ChangeBotState( LICH_BOT_STATE_IDLE )
		end

		self:AttackTarget( self.hAttackTarget )

		if self.hAbilityFrostBlast and self.hAbilityFrostBlast:IsFullyCastable() then
			self:ChangeBotState( LICH_BOT_STATE_FROST_BLAST )
		end

	elseif self.nBotState == LICH_BOT_STATE_FROST_BLAST then

		if self.hAttackTarget ~= nil and self.hAttackTarget:IsNull() == false and self.hAttackTarget:IsAlive() == true then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				AbilityIndex = self.hAbilityFrostBlast:entindex(),
				TargetIndex = self.hAttackTarget:entindex(),
			} )
			
			if self.hAbilityFrostBlast and not self.hAbilityFrostBlast:IsFullyCastable() then
				self:ChangeBotState( LICH_BOT_STATE_ATTACK )
			end
		else
			self:ChangeBotState( LICH_BOT_STATE_IDLE )
		end

	elseif self.nBotState == LICH_BOT_STATE_TP_OUT then
		if self.hTpScroll and self.hTpScroll:IsNull() == false then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self.hTpScroll:entindex(),
				Position = self.hTpPosition:GetAbsOrigin(),
			} )
			
			if self.hTpScroll and not self.hTpScroll:IsFullyCastable() and not self.hTpScroll:IsChanneling() then
				self.bTpOut = false
				self:ChangeBotState( LICH_BOT_STATE_IDLE )
			end
		end

	end
end

-----------------------------------------------------------------------------------------------------

function CRoshanLichBot:AttackTarget( hTarget )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hTarget:entindex(),
	} )

end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "LichThink", LichThink, 0.25 )
		thisEntity.Bot = CRoshanLichBot( thisEntity )
	end
end

-----------------------------------------------------------------------------------------------------

function LichThink()
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

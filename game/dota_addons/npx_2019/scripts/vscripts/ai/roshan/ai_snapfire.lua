
local SNAPFIRE_BOT_STATE_INTRO					= 0
local SNAPFIRE_BOT_STATE_IDLE					= 1
local SNAPFIRE_BOT_STATE_ENTER_PIT				= 2
local SNAPFIRE_BOT_STATE_ATTACK					= 3
local SNAPFIRE_BOT_STATE_SCATTERBLAST			= 4
local SNAPFIRE_BOT_STATE_TP_OUT					= 5

-----------------------------------------------------------------------------------------------------

if CRoshanSnapfireBot == nil then
	CRoshanSnapfireBot = class({})
end

-----------------------------------------------------------------------------------------------------

function CRoshanSnapfireBot:constructor( me )
	self.me = me
	self.hAbilityScatterblast = self.me:FindAbilityByName( "snapfire_scatterblast" )
	self.hAbilityLilShredder = self.me:FindAbilityByName( "snapfire_lil_shredder" )
	self.nBotState = SNAPFIRE_BOT_STATE_INTRO
	self.hAttackTarget = nil

	self.hStartPosition = Entities:FindByName( nil, "snapfire_start_pos" )
	self.hPitPosition = Entities:FindByName( nil, "snapfire_pit_pos" )
	self.hTpPosition = Entities:FindByName( nil, "snapfire_tp_pos" )

	self.bMoveToPit = false
	self.bTpOut = false
end

-----------------------------------------------------------------------------------------------------

function CRoshanSnapfireBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

-----------------------------------------------------------------------------------------------------

function CRoshanSnapfireBot:SetMoveToPit( bMoveToPit )
	self.bMoveToPit = bMoveToPit
end

-----------------------------------------------------------------------------------------------------

function CRoshanSnapfireBot:SetTpOut( bTpOut )
	self.bTpOut = bTpOut
end

-----------------------------------------------------------------------------------------------------

function CRoshanSnapfireBot:BotThink()

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

	if self.nBotState == SNAPFIRE_BOT_STATE_INTRO then
		if self.bMoveToPit == true then
			if self.hPitPosition ~= nil then

				ExecuteOrderFromTable( {
					UnitIndex = self.me:entindex(),
					OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
					Position = self.hPitPosition:GetAbsOrigin(),
					Queue = false,
				} )

				self:ChangeBotState( SNAPFIRE_BOT_STATE_ENTER_PIT )
			end
		end

	elseif self.nBotState == SNAPFIRE_BOT_STATE_ENTER_PIT then

		-- switch to roshan battle mode once we're close enough
		if self.hPitPosition ~= nil then
			local fDistanceToGoal = ( self.me:GetAbsOrigin() - self.hPitPosition:GetAbsOrigin() ):Length2D()
			if fDistanceToGoal < 200 then
				print( 'SNAPFIRE BOT - in the pit! switching to IDLE' )
				self:ChangeBotState( SNAPFIRE_BOT_STATE_IDLE )
			end
		end

	elseif self.nBotState == SNAPFIRE_BOT_STATE_IDLE then

		if self.bTpOut == true then
			self:ChangeBotState( SNAPFIRE_BOT_STATE_TP_OUT )
			return
		end

		local hUnits = FindUnitsInRadius( self.me:GetTeamNumber(), self.me:GetOrigin(), self.me, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
		if #hUnits > 0 then
			self.hAttackTarget = hUnits[1]
			self:ChangeBotState( SNAPFIRE_BOT_STATE_ATTACK )
		end
	
	elseif self.nBotState == SNAPFIRE_BOT_STATE_ATTACK then
		
		if not self.hAttackTarget:IsAlive() then
			self:ChangeBotState( SNAPFIRE_BOT_STATE_IDLE )
		end

		self:AttackTarget( self.hAttackTarget )

		if self.hAbilityLilShredder and self.hAbilityLilShredder:IsFullyCastable() then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self.hAbilityLilShredder:entindex(),
			} )
		end

		if self.hAbilityScatterblast and self.hAbilityScatterblast:IsFullyCastable() then
			self:ChangeBotState( SNAPFIRE_BOT_STATE_SCATTERBLAST )
		end

	elseif self.nBotState == SNAPFIRE_BOT_STATE_SCATTERBLAST then

		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.hAbilityScatterblast:entindex(),
			Position = self.hAttackTarget:GetAbsOrigin()
		} )
		
		if self.hAbilityScatterblast and not self.hAbilityScatterblast:IsFullyCastable() then
			self:ChangeBotState( SNAPFIRE_BOT_STATE_ATTACK )
		end


	elseif self.nBotState == SNAPFIRE_BOT_STATE_TP_OUT then
		if self.hTpScroll and self.hTpScroll:IsNull() == false then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self.hTpScroll:entindex(),
				Position = self.hTpPosition:GetAbsOrigin(),
			} )
			
			if self.hTpScroll and not self.hTpScroll:IsFullyCastable() and not self.hTpScroll:IsChanneling() then
				self.bTpOut = false
				self:ChangeBotState( SNAPFIRE_BOT_STATE_IDLE )
			end
		end
	end

end

-----------------------------------------------------------------------------------------------------

function CRoshanSnapfireBot:AttackTarget( hTarget )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hTarget:entindex(),
	} )

end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "SnapfireThink", SnapfireThink, 0.25 )
		thisEntity.Bot = CRoshanSnapfireBot( thisEntity )
	end
end

-----------------------------------------------------------------------------------------------------

function SnapfireThink()
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

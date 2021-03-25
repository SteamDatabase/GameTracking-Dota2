
local MIRANA_BOT_STATE_IDLE						= 0
local MIRANA_BOT_STATE_SHOOTING_ARROW			= 1
local MIRANA_BOT_STATE_WAITING_FOR_ARROW_TO_HIT	= 2
local MIRANA_BOT_STATE_KILL_TARGET				= 3
local MIRANA_BOT_STATE_RETREAT					= 4

-----------------------------------------------------------------------------------------------------

if CBasicsIntroMiranaBot == nil then
	CBasicsIntroMiranaBot = class({})
end

function CBasicsIntroMiranaBot:constructor( me )
	self.me = me

	self.hAbilityArrow = self.me:FindAbilityByName( "mirana_arrow" )
	self.hAbilityStarfall = self.me:FindAbilityByName( "mirana_starfall" )
	self.hAbilityLeap = self.me:FindAbilityByName( "mirana_leap" )

	self.nBotState = MIRANA_BOT_STATE_IDLE
	self.hAttackTarget = nil
end

function CBasicsIntroMiranaBot:SetScriptedAttackTarget( hTarget )
	self.hAttackTarget = hTarget
	self:ChangeBotState( MIRANA_BOT_STATE_SHOOTING_ARROW )
	self.flStateStartTime = 0.0
end

function CBasicsIntroMiranaBot:ChangeBotState( nNewState )
	-- print( "Mirana changing from state " .. self.nBotState .. " to " .. nNewState )
	self.nBotState = nNewState
end

function CBasicsIntroMiranaBot:BotThink()

	if self.nBotState == MIRANA_BOT_STATE_IDLE then

		-- nothing to do

	elseif self.nBotState == MIRANA_BOT_STATE_SHOOTING_ARROW then

		if self.hAbilityArrow:IsFullyCastable() then
			self:ShootArrowAtTarget( self.hAttackTarget )
			self:ChangeBotState( MIRANA_BOT_STATE_WAITING_FOR_ARROW_TO_HIT )
			self.flStateStartTime = GameRules:GetGameTime()
		end

	elseif self.nBotState == MIRANA_BOT_STATE_WAITING_FOR_ARROW_TO_HIT then
		
		-- Did they dodge it?
		if GameRules:GetGameTime() > self.flStateStartTime + 3.0 then
			self:ChangeBotState( MIRANA_BOT_STATE_RETREAT )
		end

		-- Did it hit?
		local hModifier = self.hAttackTarget:FindModifierByName( "modifier_stunned" )
		if hModifier ~= nil then
			self:ChangeBotState( MIRANA_BOT_STATE_KILL_TARGET )
		end

	elseif self.nBotState == MIRANA_BOT_STATE_KILL_TARGET then

		if not self.hAttackTarget:IsAlive() then
			return
		end

		-- Are we close enough to cast starfall?
		local nStarfallRadius = self.hAbilityStarfall:GetAOERadius()
		local vMiranaPos = self.me:GetAbsOrigin()
		local vTargetPos = self.hAttackTarget:GetAbsOrigin()
		local vPositionDiff = vTargetPos - vMiranaPos

		if vPositionDiff:Length2D() > nStarfallRadius - 100 then
			if self.hAbilityLeap and self.hAbilityLeap:IsFullyCastable() then

				local vMiranaFacingNormalized = self.me:GetForwardVector():Normalized()
				local vPositionDiffNormalized = vPositionDiff:Normalized()

				if vMiranaFacingNormalized:Dot( vPositionDiffNormalized ) > 0.9 then
					ExecuteOrderFromTable( {
						UnitIndex = self.me:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
						AbilityIndex = self.hAbilityLeap:entindex()
					} )
				end

				return
			end

			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,
				TargetIndex = self.hAttackTarget:entindex()
			} )

			return
		end

		local hEtherealBlade = FindItemByName( self.me, "item_ethereal_blade" )
		if hEtherealBlade and hEtherealBlade:IsFullyCastable() then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				AbilityIndex = hEtherealBlade:entindex(),
				TargetIndex = self.hAttackTarget:entindex()
			} )
			return
		end

		if self.hAbilityStarfall and self.hAbilityStarfall:IsFullyCastable() then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self.hAbilityStarfall:entindex()
			} )
			return
		end

		local hDagon = FindItemByName( self.me, "item_dagon_5" )
		if hDagon and hDagon:IsFullyCastable() then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				AbilityIndex = hDagon:entindex(),
				TargetIndex = self.hAttackTarget:entindex()
			} )
			return
		end

	elseif self.nBotState == MIRANA_BOT_STATE_RETREAT then

		local hRetreatEntity = Entities:FindByName( nil, "mirana_retreat_location" )
		
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = hRetreatEntity:GetAbsOrigin()
		} )

		self:ChangeBotState( MIRANA_BOT_STATE_IDLE )

	end
end


function CBasicsIntroMiranaBot:ShootArrowAtPosition( vPosition )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = self.hAbilityArrow:entindex(),
		Position = vPosition
	} )
end

function CBasicsIntroMiranaBot:ShootArrowAtTarget( hTarget )
	if hTarget == nil then
		print( "Can't shoot arrow at a nil target" )
		return
	end

	self:ShootArrowAtPosition( hTarget:GetAbsOrigin() )
end

function CBasicsIntroMiranaBot:AttackTarget( hTarget )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hTarget:entindex(),
	} )
end

function FindItemByName( hUnit, strItemName )
	for iSlot = DOTA_ITEM_SLOT_1,DOTA_ITEM_MAX do
		local hItem = hUnit:GetItemInSlot( iSlot )
		if hItem and hItem:GetAbilityName() == strItemName then
			return hItem
		end
	end
end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "BasicsIntroMiranaThink", BasicsIntroMiranaThink, 0.25 )

		thisEntity.Bot = CBasicsIntroMiranaBot( thisEntity )
	end
end

function BasicsIntroMiranaThink()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 0.1
end



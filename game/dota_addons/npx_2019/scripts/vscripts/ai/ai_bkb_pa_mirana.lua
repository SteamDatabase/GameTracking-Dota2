
local MIRANA_BOT_STATE_IDLE						= 0
local MIRANA_BOT_STATE_SHOOTING_ARROW			= 1
local MIRANA_BOT_STATE_KILL_TARGET				= 2
local MIRANA_BOT_STATE_RETREAT					= 3

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
	if self.hAttackTarget == hTarget then
		return
	end

	self.hAttackTarget = hTarget
	self:ChangeBotState( MIRANA_BOT_STATE_SHOOTING_ARROW )
	self.flStateStartTime = 0.0
end

function CBasicsIntroMiranaBot:StateName( nState )
	if nState == MIRANA_BOT_STATE_IDLE then return "Idle"
	elseif nState == MIRANA_BOT_STATE_KILL_TARGET then return "KILL_TARGET"
	elseif nState == MIRANA_BOT_STATE_RETREAT then return "RETREAT"
	elseif nState == MIRANA_BOT_STATE_SHOOTING_ARROW then return "SHOOTING_ARROW"
	else return "UNKNOWN" end
end

function CBasicsIntroMiranaBot:ChangeBotState( nNewState )
	print( "++++++++++Mirana changing from state " .. self:StateName( self.nBotState ) .. " to " .. self:StateName( nNewState ) )
	self.nBotState = nNewState
end

function CBasicsIntroMiranaBot:BotThink()
	print( "...Mirana in state " .. self:StateName( self.nBotState ) )
	if self.nBotState == MIRANA_BOT_STATE_IDLE then

		-- nothing to do

	elseif self.nBotState == MIRANA_BOT_STATE_SHOOTING_ARROW then

		if self.hAbilityArrow:IsFullyCastable() then
			self:ShootArrowAtTarget( self.hAttackTarget )
			self:ChangeBotState( MIRANA_BOT_STATE_KILL_TARGET )
		end

	elseif self.nBotState == MIRANA_BOT_STATE_KILL_TARGET then

		if not self.hAttackTarget:IsAlive() then
			return
		end

		if self.hAbilityArrow:IsFullyCastable() then
			self:ShootArrowAtTarget( self.hAttackTarget )
			return
		end

		print( "--------Mirana health Pct " .. ( self.me:GetHealth() / self.me:GetMaxHealth() ) )

		if self.me:GetHealth() < self.me:GetMaxHealth() * 0.3 then
			self:ChangeBotState( MIRANA_BOT_STATE_RETREAT )
			return
		end

		-- Are we close enough to cast starfall?
		local nStarfallRadius = self.hAbilityStarfall:GetAOERadius()
		local vMiranaPos = self.me:GetAbsOrigin()
		local vTargetPos = self.hAttackTarget:GetAbsOrigin()
		local vPositionDiff = vTargetPos - vMiranaPos

		-- Two branches: magic immune or no
		if self.hAttackTarget:IsMagicImmune() then
			-- TODO should we cast starfall even if immune? Yes for now.
			if vPositionDiff:Length2D() < nStarfallRadius - 20 and self.hAbilityStarfall and self.hAbilityStarfall:IsFullyCastable() then
				ExecuteOrderFromTable( {
					UnitIndex = self.me:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = self.hAbilityStarfall:entindex(),
					Queue = false,
				} )
			else
				-- else just attack
				self:AttackTarget( self.hAttackTarget )
			end
			return
		end

		-- target not magic immune

		if vPositionDiff:Length2D() > nStarfallRadius - 100 then
			if self.hAbilityLeap and self.hAbilityLeap:IsFullyCastable() then

				local vMiranaFacingNormalized = self.me:GetForwardVector():Normalized()
				local vPositionDiffNormalized = vPositionDiff:Normalized()

				if vMiranaFacingNormalized:Dot( vPositionDiffNormalized ) > 0.9 then
					ExecuteOrderFromTable( {
						UnitIndex = self.me:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
						AbilityIndex = self.hAbilityLeap:entindex(),
						Queue = false,
					} )
				end

				return
			end

			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,
				TargetIndex = self.hAttackTarget:entindex(),
				Queue = false,
			} )

			return
		end

		local hEtherealBlade = FindItemByName( self.me, "item_ethereal_blade" )
		if hEtherealBlade and hEtherealBlade:IsFullyCastable() then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				AbilityIndex = hEtherealBlade:entindex(),
				TargetIndex = self.hAttackTarget:entindex(),
				Queue = false,
			} )
			return
		end

		if self.hAbilityStarfall and self.hAbilityStarfall:IsFullyCastable() then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self.hAbilityStarfall:entindex(),
				Queue = false,
			} )
			return
		end

		local hDagon = FindItemByName( self.me, "item_dagon_5" )
		if hDagon and hDagon:IsFullyCastable() then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				AbilityIndex = hDagon:entindex(),
				TargetIndex = self.hAttackTarget:entindex(),
				Queue = false,
			} )
			return
		end

		-- Else just attack.
		self:AttackTarget( self.hAttackTarget )

	elseif self.nBotState == MIRANA_BOT_STATE_RETREAT then

		if self.me:GetHealth() > self.me:GetMaxHealth() * 0.75 then
			self:ChangeBotState( MIRANA_BOT_STATE_KILL_TARGET )
			return
		end
		
		local hRetreatEntity = Entities:FindByName( nil, "mirana_retreat_location" )
		local vMiranaPos = self.me:GetAbsOrigin()
		local vTargetPos = hRetreatEntity:GetAbsOrigin()
		local vPositionDiff = vTargetPos - vMiranaPos
		-- if we're close, loop back to start
		if vPositionDiff:Length2D() < 300 then
			hRetreatEntity = Entities:FindByName( nil, "mirana_spawn_location" )
			vTargetPos = hRetreatEntity:GetAbsOrigin()
			vPositionDiff = vTargetPos - vMiranaPos
		end

		if self.hAbilityLeap and self.hAbilityLeap:IsFullyCastable() then
			
			local vMiranaFacingNormalized = self.me:GetForwardVector():Normalized()
			local vPositionDiffNormalized = vPositionDiff:Normalized()

			if vMiranaFacingNormalized:Dot( vPositionDiffNormalized ) > 0.9 then
				ExecuteOrderFromTable( {
					UnitIndex = self.me:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = self.hAbilityLeap:entindex(),
					Queue = false,
				} )
				return
			end
		end
		
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = hRetreatEntity:GetAbsOrigin(),
			Queue = false,
		} )

		
		--self:ChangeBotState( MIRANA_BOT_STATE_IDLE )

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



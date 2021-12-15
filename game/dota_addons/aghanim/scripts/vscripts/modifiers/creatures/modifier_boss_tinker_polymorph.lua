
modifier_boss_tinker_polymorph = class({})

-----------------------------------------------------------------------------------------

function modifier_boss_tinker_polymorph:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_polymorph:OnCreated( kv )
	if IsServer() then
		self.movement_speed_pct = self:GetAbility():GetSpecialValueFor( "movement_speed_pct" )
		self.turn_rate_pct = self:GetAbility():GetSpecialValueFor( "turn_rate_pct" )

		self:SetHasCustomTransmitterData( true )
	end
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_polymorph:AddCustomTransmitterData( )
	return
	{
		movement_speed_pct = self.movement_speed_pct,
		turn_rate_pct = self.turn_rate_pct,
	}
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_polymorph:HandleCustomTransmitterData( data )
	self.movement_speed_pct = data.movement_speed_pct
	self.turn_rate_pct = data.turn_rate_pct
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_polymorph:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_polymorph:GetModifierModelChange( params )
	return "models/items/hex/sheep_hex/sheep_hex.vmdl"
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_polymorph:GetModifierMoveSpeedBonus_Percentage( params )
	return -self.movement_speed_pct
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_polymorph:GetModifierTurnRate_Percentage( params )
	return -self.turn_rate_pct
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_polymorph:CheckState()
	local state =
	{
		[ MODIFIER_STATE_SILENCED ] = true,
		[ MODIFIER_STATE_MUTED ] = true,
		[ MODIFIER_STATE_DISARMED ] = true,
		[ MODIFIER_STATE_HEXED ] = true,
	}

	return state
end

--------------------------------------------------------------------------------

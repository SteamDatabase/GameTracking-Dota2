
modifier_temple_guardian_passive = class({})

-----------------------------------------------------------------------------------------

function modifier_temple_guardian_passive:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_temple_guardian_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_temple_guardian_passive:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end

--------------------------------------------------------------------------------

function modifier_temple_guardian_passive:OnCreated( kv )
	if IsServer() then
		self.nonrage_status_resistance = self:GetAbility():GetSpecialValueFor( "nonrage_status_resistance" )
		self.rage_move_speed_bonus = self:GetAbility():GetSpecialValueFor( "rage_move_speed_bonus" )
		self.rage_model_scale_bonus = self:GetAbility():GetSpecialValueFor( "rage_model_scale_bonus" )
		self.rage_turn_rate_bonus_pct = self:GetAbility():GetSpecialValueFor( "rage_turn_rate_bonus_pct" )
	end
end


-----------------------------------------------------------------------------------------

function modifier_temple_guardian_passive:CheckState()
	local state =
	{
		[ MODIFIER_STATE_FEARED ] = false,
		[ MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED ] = true,
		[ MODIFIER_STATE_UNSLOWABLE ] = true,
	}

	return state
end

-----------------------------------------------------------------------------------------

function modifier_temple_guardian_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_temple_guardian_passive:GetModifierStatusResistanceStacking( params )
	if IsServer() then
		if self:GetParent().bIsEnraged == true then
			return 100
		end
	end

	return self.nonrage_status_resistance
end

--------------------------------------------------------------------------------

function modifier_temple_guardian_passive:GetModifierMoveSpeedBonus_Constant( params )
	if IsServer() then
		if self:GetParent().bIsEnraged == true then
			return self.rage_move_speed_bonus
		end
	end

	return 0
end

-----------------------------------------------------------------------------------------

function modifier_temple_guardian_passive:GetModifierModelScale( params )
	if IsServer() then
		if self:GetParent().bIsEnraged == true then
			return self.rage_model_scale_bonus
		end
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_temple_guardian_passive:GetModifierTurnRate_Percentage( params )
	if IsServer() then
		if self:GetParent().bIsEnraged == true then
			return self.rage_turn_rate_bonus_pct
		end
	end

	return 0
end

--------------------------------------------------------------------------------

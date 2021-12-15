
modifier_boss_tinker_enraged = class({})

---------------------------------------------------------------------------

function modifier_boss_tinker_enraged:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_enraged:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_enraged:OnCreated( kv )
	self.enraged_model_scale = self:GetAbility():GetSpecialValueFor( "enraged_model_scale" )
	self.enraged_bonus_ms = self:GetAbility():GetSpecialValueFor( "enraged_bonus_ms" )
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_enraged:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_enraged:GetModifierModelScale( params )
	return self.enraged_model_scale
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_enraged:GetModifierMoveSpeedBonus_Percentage( params )
	return self.enraged_bonus_ms
end

--------------------------------------------------------------------------------

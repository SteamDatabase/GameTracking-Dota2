
modifier_boss_tinker_shivas = class({})

---------------------------------------------------------------------------

function modifier_boss_tinker_shivas:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_shivas:GetEffectName()
	return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_shivas:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_shivas:StatusEffectPriority()
	return 10
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_shivas:OnCreated( kv )
	self.blast_movement_slow = self:GetAbility():GetSpecialValueFor( "blast_movement_slow" )
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_shivas:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_shivas:GetModifierMoveSpeedBonus_Percentage( params )
	return -self.blast_movement_slow
end

--------------------------------------------------------------------------------

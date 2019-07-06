
modifier_jungle_spirit_greater_hex = class({})

--------------------------------------------------------------------------------

function modifier_jungle_spirit_greater_hex:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_greater_hex:GetEffectName()
	return "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_slow.vpcf"
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_greater_hex:GetStatusEffectName()
	return "particles/status_fx/status_effect_wyvern_arctic_burn.vpcf"
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_greater_hex:OnCreated( kv )
	self.movespeed_slow = self:GetAbility():GetSpecialValueFor( "movespeed_slow" )

	if IsServer() then
		EmitSoundOn( "JungleSpirit.Hex.Target", self:GetParent() )
	end
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_greater_hex:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_greater_hex:GetModifierMoveSpeedBonus_Percentage( params )
	return -self.movespeed_slow
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_greater_hex:GetModifierModelChange( params )
	return "models/courier/frog/frog.vmdl"
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_greater_hex:GetModifierModelScale( params )
	return 50
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_greater_hex:CheckState()
	local state = {
		[ MODIFIER_STATE_MUTED ] = true,
		[ MODIFIER_STATE_SILENCED ] = true,
		[ MODIFIER_STATE_DISARMED ] = true,
	}

	return state
end

--------------------------------------------------------------------------------

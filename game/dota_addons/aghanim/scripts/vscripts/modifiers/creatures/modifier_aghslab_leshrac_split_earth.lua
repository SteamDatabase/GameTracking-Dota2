modifier_aghslab_leshrac_split_earth = class({})

--------------------------------------------------------------------------------

function modifier_aghslab_leshrac_split_earth:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_aghslab_leshrac_split_earth:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_aghslab_leshrac_split_earth:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

--------------------------------------------------------------------------------

function modifier_aghslab_leshrac_split_earth:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_aghslab_leshrac_split_earth:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_aghslab_leshrac_split_earth:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_aghslab_leshrac_split_earth:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

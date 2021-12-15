modifier_aghslab_night_stalker_void = class({})

--------------------------------------------------------------------------------

function modifier_aghslab_night_stalker_void:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_aghslab_night_stalker_void:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_aghslab_night_stalker_void:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

--------------------------------------------------------------------------------

function modifier_aghslab_night_stalker_void:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_aghslab_night_stalker_void:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_ATTACKSPEED_BASE_OVERRIDE
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_aghslab_night_stalker_void:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_aghslab_night_stalker_void:GetModifierMoveSpeed_Limit( params )
	local hUnit = self:GetParent()
	local flUnitSpeed = hUnit:GetBaseMoveSpeed()
	local flModifiedSpeed = flUnitSpeed * 0.5
	return flModifiedSpeed
end

--------------------------------------------------------------------------------

function modifier_aghslab_night_stalker_void:GetModifierAttackSpeedBaseOverride( params )
	local hUnit = self:GetParent()
	local flAttackSpeed = hUnit:GetBaseMoveSpeed()
	local flModifiedAttackSpeed = flAttackSpeed * 0.5
	return flModifiedAttackSpeed
end

--------------------------------------------------------------------------------

function modifier_aghslab_night_stalker_void:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

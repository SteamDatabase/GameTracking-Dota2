
modifier_pugna_ward_winter = class({})

--------------------------------------------------------------------------------

function modifier_pugna_ward_winter:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_pugna_ward_winter:GetModifierAura()
	return "modifier_pugna_ward_winter_effect"
end
--------------------------------------------------------------------------------

function modifier_pugna_ward_winter:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_pugna_ward_winter:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

--------------------------------------------------------------------------------

function modifier_pugna_ward_winter:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
end
--------------------------------------------------------------------------------

function modifier_pugna_ward_winter:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_pugna_ward_winter:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

--------------------------------------------------------------------------------

function modifier_pugna_ward_winter:CheckState()
	local state = {}
	if IsServer()  then
		state[MODIFIER_STATE_ROOTED] = true
	end

	return state
end
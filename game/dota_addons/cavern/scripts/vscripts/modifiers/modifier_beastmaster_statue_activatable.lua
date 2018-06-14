
modifier_beastmaster_statue_activatable = class({})

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_activatable:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_activatable:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_activatable:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_activatable:GetModifierAura()
	return "modifier_beastmaster_statue_aura_effect"
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_activatable:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_activatable:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_activatable:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_activatable:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

--------------------------------------------------------------------------------

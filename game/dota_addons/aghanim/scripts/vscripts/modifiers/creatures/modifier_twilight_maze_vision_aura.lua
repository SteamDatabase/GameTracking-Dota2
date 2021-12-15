
modifier_twilight_maze_vision_aura = class({})

--------------------------------------------------------------------------------

function modifier_twilight_maze_vision_aura:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_twilight_maze_vision_aura:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_twilight_maze_vision_aura:GetModifierAura()
	return "modifier_twilight_maze_vision_aura_effect"
end

--------------------------------------------------------------------------------

function modifier_twilight_maze_vision_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

----------------------------------------------------------------------------------------

function modifier_twilight_maze_vision_aura:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

--------------------------------------------------------------------------------

function modifier_twilight_maze_vision_aura:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

--------------------------------------------------------------------------------

function modifier_twilight_maze_vision_aura:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_twilight_maze_vision_aura:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

--------------------------------------------------------------------------------

function modifier_twilight_maze_vision_aura:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

--------------------------------------------------------------------------------

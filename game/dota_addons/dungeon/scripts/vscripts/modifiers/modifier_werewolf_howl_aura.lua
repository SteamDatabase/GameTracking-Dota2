modifier_werewolf_howl_aura = class({})

----------------------------------------

function modifier_werewolf_howl_aura:IsAura()
	return true
end

----------------------------------------

function modifier_werewolf_howl_aura:GetModifierAura()
	return  "modifier_werewolf_howl_aura_effect"
end

----------------------------------------

function modifier_werewolf_howl_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

----------------------------------------

function modifier_werewolf_howl_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

----------------------------------------

function modifier_werewolf_howl_aura:GetAuraRadius()
	return self.radius
end

----------------------------------------

function modifier_werewolf_howl_aura:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

----------------------------------------

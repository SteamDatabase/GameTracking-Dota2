
modifier_primal_beast_outro_aura = class({})

--------------------------------------------------------------------------------

function modifier_primal_beast_outro_aura:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_primal_beast_outro_aura:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_primal_beast_outro_aura:GetAuraDuration()
	return 10
end

--------------------------------------------------------------------------------

function modifier_primal_beast_outro_aura:GetModifierAura()
	return "modifier_primal_beast_outro_aura_effect"
end

--------------------------------------------------------------------------------

function modifier_primal_beast_outro_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_primal_beast_outro_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_primal_beast_outro_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_primal_beast_outro_aura:GetAuraRadius()
	return 10000
end


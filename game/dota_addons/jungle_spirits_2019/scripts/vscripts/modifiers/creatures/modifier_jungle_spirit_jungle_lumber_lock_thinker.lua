modifier_jungle_spirit_jungle_lumber_lock_thinker = class({})

--------------------------------------------------------------------------------

function modifier_jungle_spirit_jungle_lumber_lock_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_jungle_lumber_lock_thinker:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_jungle_lumber_lock_thinker:GetModifierAura()
	return "modifier_jungle_spirit_jungle_lumber_lock"
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_jungle_lumber_lock_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_jungle_lumber_lock_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_jungle_lumber_lock_thinker:GetAuraRadius()
	return FIND_UNITS_EVERYWHERE
end
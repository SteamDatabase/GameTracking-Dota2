modifier_jungle_spirit_volcano_fire_strike_thinker = class({})

--------------------------------------------------------------------------------

function modifier_jungle_spirit_volcano_fire_strike_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_volcano_fire_strike_thinker:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_volcano_fire_strike_thinker:GetModifierAura()
	return "modifier_jungle_spirit_volcano_fire_strike"
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_volcano_fire_strike_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_volcano_fire_strike_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_volcano_fire_strike_thinker:GetAuraRadius()
	return FIND_UNITS_EVERYWHERE
end
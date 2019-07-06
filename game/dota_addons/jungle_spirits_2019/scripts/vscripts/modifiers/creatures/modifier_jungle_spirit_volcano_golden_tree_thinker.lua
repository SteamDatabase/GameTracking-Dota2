modifier_jungle_spirit_volcano_golden_tree_thinker = class({})

--------------------------------------------------------------------------------

function modifier_jungle_spirit_volcano_golden_tree_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_volcano_golden_tree_thinker:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_volcano_golden_tree_thinker:GetModifierAura()
	return "modifier_jungle_spirit_volcano_golden_tree"
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_volcano_golden_tree_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_volcano_golden_tree_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_volcano_golden_tree_thinker:GetAuraRadius()
	return FIND_UNITS_EVERYWHERE
end
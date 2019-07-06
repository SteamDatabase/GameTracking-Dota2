modifier_jungle_spirit_jungle_building_regeneration_thinker = class({})

--------------------------------------------------------------------------------

function modifier_jungle_spirit_jungle_building_regeneration_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_jungle_building_regeneration_thinker:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_jungle_building_regeneration_thinker:GetModifierAura()
	return "modifier_jungle_spirit_jungle_building_regeneration"
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_jungle_building_regeneration_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_jungle_building_regeneration_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BUILDING
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_jungle_building_regeneration_thinker:GetAuraRadius()
	return FIND_UNITS_EVERYWHERE
end
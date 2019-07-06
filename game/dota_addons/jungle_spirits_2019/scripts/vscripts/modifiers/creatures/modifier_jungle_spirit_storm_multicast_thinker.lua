modifier_jungle_spirit_storm_multicast_thinker = class({})

--------------------------------------------------------------------------------

function modifier_jungle_spirit_storm_multicast_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_storm_multicast_thinker:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_storm_multicast_thinker:GetModifierAura()
	return "modifier_jungle_spirit_storm_multicast"
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_storm_multicast_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_storm_multicast_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_storm_multicast_thinker:GetAuraRadius()
	return FIND_UNITS_EVERYWHERE
end
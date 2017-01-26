modifier_creature_night_stalker_darkness_thinker = class({})

--------------------------------------------------------------------------------

function modifier_creature_night_stalker_darkness_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_creature_night_stalker_darkness_thinker:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_creature_night_stalker_darkness_thinker:GetModifierAura()
	return "modifier_creature_night_stalker_darkness_blind"
end

--------------------------------------------------------------------------------

function modifier_creature_night_stalker_darkness_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_creature_night_stalker_darkness_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BUILDING
end

--------------------------------------------------------------------------------

function modifier_creature_night_stalker_darkness_thinker:GetAuraRadius()
	return FIND_UNITS_EVERYWHERE
end

--------------------------------------------------------------------------------

function modifier_creature_night_stalker_darkness_thinker:OnDestroy()
	--[[
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
	]]
end

--------------------------------------------------------------------------------

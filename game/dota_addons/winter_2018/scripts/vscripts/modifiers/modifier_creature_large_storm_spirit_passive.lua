modifier_creature_large_storm_spirit_passive = class({})

--------------------------------------------------------------------------------

function modifier_creature_large_storm_spirit_passive:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_creature_large_storm_spirit_passive:IsHidden()
	return true;
end

--------------------------------------------------------------------------------
function modifier_creature_large_storm_spirit_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_creature_large_storm_spirit_passive:GetModifierPercentageCooldownStacking( params )
	if IsServer() then
		return 75
	end
	return 0
end

--------------------------------------------------------------------------------

function modifier_creature_large_storm_spirit_passive:GetModifierStatusResistanceStacking( params )
	return 75 
end

--------------------------------------------------------------------------------

function modifier_creature_large_storm_spirit_passive:OnCreated( kv )
	if IsServer() then
	end
end
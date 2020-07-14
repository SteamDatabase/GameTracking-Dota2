modifier_creature_generic_high_status_resist_passive = class({})

--------------------------------------------------------------------------------

function modifier_creature_generic_high_status_resist_passive:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_creature_generic_high_status_resist_passive:IsHidden()
	return true;
end

--------------------------------------------------------------------------------
function modifier_creature_generic_high_status_resist_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_creature_generic_high_status_resist_passive:GetModifierStatusResistanceStacking( params )
	return 75 
end

--------------------------------------------------------------------------------

function modifier_creature_generic_high_status_resist_passive:OnCreated( kv )
	if IsServer() then
	end
end
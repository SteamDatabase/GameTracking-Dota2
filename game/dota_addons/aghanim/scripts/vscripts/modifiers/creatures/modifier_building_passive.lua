modifier_building_passive = class({})

--------------------------------------------------------------------------------

function modifier_building_passive:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_building_passive:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_building_passive:CheckState()
	local state = {}

	if IsServer() then
		state[MODIFIER_STATE_MAGIC_IMMUNE] = true
	end

	return state
end

--------------------------------------------------------------------------------
function modifier_building_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_building_passive:GetModifierStatusResistanceStacking( params )
	return 100 
end

--------------------------------------------------------------------------------

function modifier_building_passive:OnCreated( kv )
	if IsServer() then
	end
end
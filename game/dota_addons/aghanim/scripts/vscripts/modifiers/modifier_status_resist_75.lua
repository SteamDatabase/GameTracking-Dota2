
modifier_status_resist_75 = class({})

--------------------------------------------------------------------------------

function modifier_status_resist_75:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_status_resist_75:IsHidden()
	return true;
end

--------------------------------------------------------------------------------
function modifier_status_resist_75:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_status_resist_75:GetModifierStatusResistanceStacking( params )
	return 75
end

--------------------------------------------------------------------------------

function modifier_status_resist_75:OnCreated( kv )
	if IsServer() then
	end
end

--------------------------------------------------------------------------------

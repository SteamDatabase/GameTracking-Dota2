
modifier_status_resist_50 = class({})

--------------------------------------------------------------------------------

function modifier_status_resist_50:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_status_resist_50:IsHidden()
	return true;
end

--------------------------------------------------------------------------------
function modifier_status_resist_50:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_status_resist_50:GetModifierStatusResistanceStacking( params )
	return 50
end

--------------------------------------------------------------------------------

function modifier_status_resist_50:OnCreated( kv )
	if IsServer() then
	end
end

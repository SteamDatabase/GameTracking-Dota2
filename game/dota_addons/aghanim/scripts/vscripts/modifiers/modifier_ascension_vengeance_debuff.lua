
modifier_ascension_vengeance_debuff = class({})

--------------------------------------------------------------------------------

function modifier_ascension_vengeance_debuff:GetTexture()
	return "events/aghanim/interface/hazard_net"
end

--------------------------------------------------------------------------------

function modifier_ascension_vengeance_debuff:GetEffectName()
	return "particles/items2_fx/rod_of_atos.vpcf"
end

--------------------------------------------------------------------------------

function modifier_ascension_vengeance_debuff:CheckState()
	local state =
	{
		[ MODIFIER_STATE_ROOTED ] = true,
	}

	return state
end

--------------------------------------------------------------------------------



modifier_no_xp = class({})

--------------------------------------------------------------------------------

function modifier_no_xp:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_no_xp:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_no_xp:OnCreated( kv )
	
end

--------------------------------------------------------------------------------

function modifier_no_xp:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_EXP_RATE_BOOST,
	}

	return funcs
end


function modifier_no_xp:GetModifierPercentageExpRateBoost( params )
	return -100
end

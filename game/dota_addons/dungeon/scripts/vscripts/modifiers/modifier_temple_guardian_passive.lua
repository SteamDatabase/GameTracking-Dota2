modifier_temple_guardian_passive = class({})

-----------------------------------------------------------------------------------------

function modifier_temple_guardian_passive:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_temple_guardian_passive:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_temple_guardian_passive:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}
	return funcs
end

-----------------------------------------------------------------------------------------


function modifier_temple_guardian_passive:GetModifierMoveSpeed_Absolute( params )
	return 300
end

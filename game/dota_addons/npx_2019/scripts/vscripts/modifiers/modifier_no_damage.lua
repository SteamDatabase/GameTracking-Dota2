
if modifier_no_damage == nil then
	modifier_no_damage = class( {} )
end

-----------------------------------------------------------------------------

function modifier_no_damage:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_no_damage:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_no_damage:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	}

	return funcs
end

-----------------------------------------------------------------------------

function modifier_no_damage:GetAbsoluteNoDamagePhysical( params)
	return 1
end

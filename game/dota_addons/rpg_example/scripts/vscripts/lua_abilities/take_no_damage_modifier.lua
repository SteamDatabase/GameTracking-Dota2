if take_no_damage_modifier == nil then
	take_no_damage_modifier = class({})
end

function take_no_damage_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}

	return funcs
end

function take_no_damage_modifier:GetAbsoluteNoDamageMagical( params )
	return 1
end

function take_no_damage_modifier:GetAbsoluteNoDamagePhysical( params )
	return 1
end

function take_no_damage_modifier:GetAbsoluteNoDamagePure( params )
	return 1
end
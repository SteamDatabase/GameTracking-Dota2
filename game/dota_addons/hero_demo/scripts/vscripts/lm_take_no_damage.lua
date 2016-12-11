lm_take_no_damage = class({})

function lm_take_no_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}

	return funcs
end

function lm_take_no_damage:GetAbsoluteNoDamageMagical( params )
	return 1
end

function lm_take_no_damage:GetAbsoluteNoDamagePhysical( params )
	return 1
end

function lm_take_no_damage:GetAbsoluteNoDamagePure( params )
	return 1
end
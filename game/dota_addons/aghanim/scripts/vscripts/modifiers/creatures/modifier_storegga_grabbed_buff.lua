
modifier_storegga_grabbed_buff = class({})

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_buff:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_buff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_buff:GetActivityTranslationModifiers( params )
	return "tree"
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_buff:GetModifierTurnRate_Percentage( params )
	return -90
end

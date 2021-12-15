modifier_aghanim_animation_activity_modifier = class({})

--------------------------------------------------------------------------------

function modifier_aghanim_animation_activity_modifier:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_aghanim_animation_activity_modifier:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_aghanim_animation_activity_modifier:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_aghanim_animation_activity_modifier:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 100000
end

--------------------------------------------------------------------------------

function modifier_aghanim_animation_activity_modifier:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_aghanim_animation_activity_modifier:GetActivityTranslationModifiers( params )
	return "aghs_lab_2021"
end

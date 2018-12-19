modifier_rubick_boss_linear_fade_bolts = class({})

-----------------------------------------------------------------------

function modifier_rubick_boss_linear_fade_bolts:IsHidden()
	return true
end

-----------------------------------------------------------------------

function modifier_rubick_boss_linear_fade_bolts:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_linear_fade_bolts:GetActivityTranslationModifiers( params )
	return "wrath"
end

-----------------------------------------------------------------------

function modifier_rubick_boss_linear_fade_bolts:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_rubick_boss_linear_fade_bolts:GetOverrideAnimation( params )
	print( "overriding")
	return ACT_DOTA_CAST_ABILITY_5
end
modifier_skeleton_king_boss_run = class({})

--------------------------------------------------------------------------------

function modifier_skeleton_king_boss_run:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_skeleton_king_boss_run:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_skeleton_king_boss_run:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_skeleton_king_boss_run:GetActivityTranslationModifiers( params )
	return "run"
end

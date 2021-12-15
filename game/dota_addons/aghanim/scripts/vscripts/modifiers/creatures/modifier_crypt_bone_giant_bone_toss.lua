modifier_crypt_bone_giant_bone_toss = class({})

--------------------------------------------------------------------------------

function modifier_crypt_bone_giant_bone_toss:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_crypt_bone_giant_bone_toss:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_crypt_bone_giant_bone_toss:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_crypt_bone_giant_bone_toss:GetActivityTranslationModifiers( params )
	return "tree"
end

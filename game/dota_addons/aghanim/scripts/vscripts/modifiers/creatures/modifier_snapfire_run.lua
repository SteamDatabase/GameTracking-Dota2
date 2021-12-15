modifier_snapfire_run = class({})

--------------------------------------------------------------------------------

function modifier_snapfire_run:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_snapfire_run:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_snapfire_run:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_snapfire_run:GetActivityTranslationModifiers( params )
	return "run"
end

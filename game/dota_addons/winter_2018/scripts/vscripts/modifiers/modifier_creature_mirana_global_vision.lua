modifier_creature_mirana_global_vision = class({})

--------------------------------------------------------------------------------

function modifier_creature_mirana_global_vision:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_creature_mirana_global_vision:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_creature_mirana_global_vision:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_creature_mirana_global_vision:DeclareFunctions()
	local funcs = {
		MODIFIER_STATE_PROVIDES_VISION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_creature_mirana_global_vision:GetModifierProvidesFOWVision( params )
	return 1
end

--------------------------------------------------------------------------------

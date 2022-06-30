modifier_trap_reveal_attacker = class ({})

--------------------------------------------------------------------------------

function modifier_trap_reveal_attacker:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_trap_reveal_attacker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_trap_reveal_attacker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_trap_reveal_attacker:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_trap_reveal_attacker:GetModifierProvidesFOWVision( params )
	return 1
end
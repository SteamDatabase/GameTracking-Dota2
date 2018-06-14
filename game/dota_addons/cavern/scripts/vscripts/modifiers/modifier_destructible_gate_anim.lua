
modifier_destructible_gate_anim = class({})

--------------------------------------------------------------------------------

function modifier_destructible_gate_anim:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_destructible_gate_anim:CanParentBeAutoAttacked()
	return false
end

--------------------------------------------------------------------------------

function modifier_destructible_gate_anim:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

--------------------------------------------------------------------------------

function modifier_destructible_gate_anim:OnCreated( kv )
	if IsServer() then
		self.hGate = self:GetParent().hGate
	end
end

--------------------------------------------------------------------------------

function modifier_destructible_gate_anim:CheckState()
	local state = {}
	state[ MODIFIER_STATE_ROOTED ] = true
	state[ MODIFIER_STATE_BLIND ] = true
	state[ MODIFIER_STATE_MAGIC_IMMUNE ] = true
	state[ MODIFIER_STATE_NO_UNIT_COLLISION ] = true
	state[ MODIFIER_STATE_NOT_ON_MINIMAP ] = true
	state[ MODIFIER_STATE_NO_HEALTH_BAR ] = true
	state[ MODIFIER_STATE_UNSELECTABLE ] = true
	state[ MODIFIER_STATE_OUT_OF_GAME ] = true

	return state
end

--------------------------------------------------------------------------------

function modifier_destructible_gate_anim:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}

	return funcs
end

-----------------------------------------------------------------------

function modifier_destructible_gate_anim:GetModifierProvidesFOWVision( params )
	return 1
end

------------------------------------------------------------

function modifier_destructible_gate_anim:GetAbsoluteNoDamageMagical( params )
	return 1
end

------------------------------------------------------------

function modifier_destructible_gate_anim:GetAbsoluteNoDamagePure( params )
	return 1
end

------------------------------------------------------------

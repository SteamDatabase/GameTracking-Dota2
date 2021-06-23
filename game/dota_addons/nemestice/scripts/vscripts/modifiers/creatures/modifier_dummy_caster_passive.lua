
modifier_dummy_caster_passive = class({})

--------------------------------------------------------------------------------

function modifier_dummy_caster_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_dummy_caster_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_dummy_caster_passive:CheckState()
	local state = {}
	if IsServer()  then
		state[ MODIFIER_STATE_INVULNERABLE ] = true
		state[ MODIFIER_STATE_MAGIC_IMMUNE ] = true
		state[ MODIFIER_STATE_UNSELECTABLE ] = true
		state[ MODIFIER_STATE_NOT_ON_MINIMAP ] = true
		state[ MODIFIER_STATE_NO_UNIT_COLLISION ] = true
		state[ MODIFIER_STATE_NO_HEALTH_BAR ] = true
		state[ MODIFIER_STATE_DISARMED ] = true
		state[ MODIFIER_STATE_ROOTED ] = true
		state[ MODIFIER_STATE_ATTACK_IMMUNE ] = true
	end

	return state
end

--------------------------------------------------------------------------------

function modifier_dummy_caster_passive:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_dummy_caster_passive:GetModifierPercentageManacost()
	return 100
end

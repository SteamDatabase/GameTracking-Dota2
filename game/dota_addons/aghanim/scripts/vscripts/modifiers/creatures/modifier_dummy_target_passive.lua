
modifier_dummy_target_passive = class({})

--------------------------------------------------------------------------------

function modifier_dummy_target_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_dummy_target_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_dummy_target_passive:CheckState()
	local state = {}

	if IsServer()  then
		state[ MODIFIER_STATE_INVULNERABLE ] = true
		state[ MODIFIER_STATE_MAGIC_IMMUNE ] = true
		state[ MODIFIER_STATE_ATTACK_IMMUNE ] = true
		state[ MODIFIER_STATE_NOT_ON_MINIMAP ] = true
		state[ MODIFIER_STATE_NO_UNIT_COLLISION ] = true
		state[ MODIFIER_STATE_NO_HEALTH_BAR ] = true
		state[ MODIFIER_STATE_DISARMED ] = true
		state[ MODIFIER_STATE_ROOTED ] = true
	end

	return state
end

--------------------------------------------------------------------------------

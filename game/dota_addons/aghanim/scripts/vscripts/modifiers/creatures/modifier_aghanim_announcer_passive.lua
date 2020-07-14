
modifier_aghanim_announcer_passive = class({})

----------------------------------------

function modifier_aghanim_announcer_passive:OnCreated( kv )
	print( "modifier_aghanim_announcer_passive" )
end

--------------------------------------------------------------------------------

function modifier_aghanim_announcer_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_aghanim_announcer_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_aghanim_announcer_passive:CheckState()
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

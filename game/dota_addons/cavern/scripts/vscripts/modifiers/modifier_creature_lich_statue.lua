
modifier_creature_lich_statue = class({})

--------------------------------------------------------------------------------

function modifier_creature_lich_statue:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_creature_lich_statue:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_creature_lich_statue:CheckState()
	local state = {}
	if IsServer() then
		state[ MODIFIER_STATE_NO_UNIT_COLLISION ] = true
		state[ MODIFIER_STATE_NO_HEALTH_BAR ] = true
		state[ MODIFIER_STATE_NOT_ON_MINIMAP ] = true
		state[ MODIFIER_STATE_ROOTED ] = true
		state[ MODIFIER_STATE_BLIND ] = true
		state[ MODIFIER_STATE_DISARMED ] = true
		state[ MODIFIER_STATE_ATTACK_IMMUNE ] = true
		state[ MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY ] = true
	end
	
	return state
end

--------------------------------------------------------------------------------

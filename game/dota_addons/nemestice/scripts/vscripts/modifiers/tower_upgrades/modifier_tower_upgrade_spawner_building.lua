modifier_tower_upgrade_spawner_building = class({})

--------------------------------------------------------------------------------

function modifier_tower_upgrade_spawner_building:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_tower_upgrade_spawner_building:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_tower_upgrade_spawner_building:CheckState()
	local state = {}
	
	state[MODIFIER_STATE_NO_HEALTH_BAR] = true
	state[MODIFIER_STATE_BLIND] = true
	state[MODIFIER_STATE_INVULNERABLE] = true
	state[MODIFIER_STATE_UNSELECTABLE] = true
	state[MODIFIER_STATE_NO_HEALTH_BAR] = true

	return state
end


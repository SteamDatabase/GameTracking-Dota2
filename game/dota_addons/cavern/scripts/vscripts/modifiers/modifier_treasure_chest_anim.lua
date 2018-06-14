
modifier_treasure_chest_anim = class({})

--------------------------------------------------------------------------------

function modifier_treasure_chest_anim:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_treasure_chest_anim:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

-----------------------------------------------------------------------

function modifier_treasure_chest_anim:OnTakeDamage( params )
	return 0
end

-----------------------------------------------------------------------

function modifier_treasure_chest_anim:GetFixedDayVision( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_treasure_chest_anim:GetFixedNightVision( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_treasure_chest_anim:CheckState()
	local state = {}
	if IsServer()  then
		state[MODIFIER_STATE_ATTACK_IMMUNE] = true
		state[MODIFIER_STATE_ROOTED] = true
		state[MODIFIER_STATE_NO_HEALTH_BAR] = true
		state[MODIFIER_STATE_BLIND] = true
		state[MODIFIER_STATE_NOT_ON_MINIMAP] = true
		state[MODIFIER_STATE_INVULNERABLE] = true
		state[MODIFIER_STATE_UNSELECTABLE] = true
		state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	end
	
	return state
end

--------------------------------------------------------------------------------

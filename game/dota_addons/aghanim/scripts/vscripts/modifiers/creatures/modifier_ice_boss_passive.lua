modifier_ice_boss_passive = class({})

-----------------------------------------------------------------------------------------

function modifier_ice_boss_passive:IsHidden()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_ice_boss_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ice_boss_passive:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

-----------------------------------------------------------------------------------------

function modifier_ice_boss_passive:OnCreated( kv )

	if IsServer() then
	end

end

-----------------------------------------------------------------------------------------

function modifier_ice_boss_passive:CheckState()
	local state =
	{
		[MODIFIER_STATE_HEXED] = false,
		[MODIFIER_STATE_ROOTED] = false,
		[MODIFIER_STATE_SILENCED] = false,
		[MODIFIER_STATE_STUNNED] = false,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}

	if IsServer() then
	end
	return state
end


modifier_boss_inactive = class({})

-----------------------------------------------------------------------------------------

function modifier_boss_inactive:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_boss_inactive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_inactive:OnCreated( kv )
	if IsServer() then
		print( "modifier_boss_inactive:OnCreated" )
	end
end

--------------------------------------------------------------------------------

function modifier_boss_inactive:OnDestroy()
	if IsServer() then
		print( "modifier_boss_inactive:OnDestroy" )
	end
end

--------------------------------------------------------------------------------

function modifier_boss_inactive:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

-----------------------------------------------------------------------------------------

function modifier_boss_inactive:CheckState()
	local state =
	{
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_BLIND] = true,
		[MODIFIER_STATE_INVISIBLE] = true,
	}

	return state
end

-----------------------------------------------------------------------------------------


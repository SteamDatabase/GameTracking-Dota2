
modifier_jungle_spirit_inactive = class({})

-----------------------------------------------------------------------------------------

function modifier_jungle_spirit_inactive:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_jungle_spirit_inactive:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_jungle_spirit_inactive:CheckState()
	local state = {}

	if IsServer() then
		state[ MODIFIER_STATE_MAGIC_IMMUNE ] = true
		state[ MODIFIER_STATE_INVULNERABLE ] = true
		state[ MODIFIER_STATE_OUT_OF_GAME ] = true
		state[ MODIFIER_STATE_ROOTED ] = true
		state[ MODIFIER_STATE_DISARMED ] = true
		state[ MODIFIER_STATE_NO_HEALTH_BAR ] = true
	end

	return state
end

-----------------------------------------------------------------------------------------

function modifier_jungle_spirit_inactive:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

-----------------------------------------------------------------------------------------


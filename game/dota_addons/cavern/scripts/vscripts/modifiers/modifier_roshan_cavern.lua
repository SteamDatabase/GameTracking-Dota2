
modifier_roshan_cavern = class({})

--------------------------------------------------------------------------------

function modifier_roshan_cavern:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_roshan_cavern:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_roshan_cavern:CheckState()
	local state = {}
	if IsServer() then
		state[ MODIFIER_STATE_NO_HEALTH_BAR ] = true
		state[ MODIFIER_STATE_INVULNERABLE ] = true
		state[ MODIFIER_STATE_OUT_OF_GAME ] = true
		state[ MODIFIER_STATE_DISARMED ] = true
		
		state[ MODIFIER_STATE_PROVIDES_VISION ] = false
	end
	
	return state
end

--------------------------------------------------------------------------------

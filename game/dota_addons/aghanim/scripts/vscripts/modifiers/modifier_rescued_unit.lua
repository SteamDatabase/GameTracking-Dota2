modifier_rescued_unit = class({})

--------------------------------------------------------------------------------

function modifier_rescued_unit:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_rescued_unit:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_rescued_unit:CheckState()
	local state = {}
	if IsServer()  then
		state[ MODIFIER_STATE_MAGIC_IMMUNE ] = true
		state[ MODIFIER_STATE_OUT_OF_GAME ] = true
		state[ MODIFIER_STATE_INVULNERABLE ] = true
		state[ MODIFIER_STATE_NO_HEALTH_BAR ] = true
		state[ MODIFIER_STATE_ROOTED ] = true
	end
	
	return state
end

--------------------------------------------------------------------------------

function modifier_rescued_unit:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end
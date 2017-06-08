
modifier_temple_guardian_immunity = class({})

-----------------------------------------------------------------------------------------

function modifier_temple_guardian_immunity:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_temple_guardian_immunity:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_temple_guardian_immunity:CheckState()
	local state = {}
	if IsServer()  then
		state[MODIFIER_STATE_MAGIC_IMMUNE] = true
		state[MODIFIER_STATE_INVULNERABLE] = true
		state[MODIFIER_STATE_OUT_OF_GAME] = true
	end
	
	return state
end

-----------------------------------------------------------------------------------------

function modifier_temple_guardian_immunity:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

-----------------------------------------------------------------------------------------


modifier_evil_greevil_passive = class({})

--------------------------------------------------------------

function modifier_evil_greevil_passive:CheckState()
	local state = {}

	if IsServer() then
		state[MODIFIER_STATE_MAGIC_IMMUNE] = true
	end
	
	return state
end

--------------------------------------------------------------


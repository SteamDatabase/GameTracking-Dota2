modifier_rooted_unpurgable = class({})

--------------------------------------------------------------------------------

function modifier_rooted_unpurgable:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_rooted_unpurgable:IsPermanent()
	return true 
end

--------------------------------------------------------------------------------

function modifier_rooted_unpurgable:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_rooted_unpurgable:CheckState()
	local state = {}

	if IsServer() then
		state[MODIFIER_STATE_ROOTED] = true
	end

	return state
end

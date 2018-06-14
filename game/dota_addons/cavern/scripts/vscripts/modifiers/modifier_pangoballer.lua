
modifier_pangoballer = class({})

--------------------------------------------------------------------------------

function modifier_pangoballer:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

--------------------------------------------------------------------------------

function modifier_pangoballer:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_pangoballer:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_pangoballer:CheckState()
	local state = {}
	if IsServer() then
		state[ MODIFIER_STATE_MAGIC_IMMUNE ] = false
	end
	
	return state
end

--------------------------------------------------------------------------------

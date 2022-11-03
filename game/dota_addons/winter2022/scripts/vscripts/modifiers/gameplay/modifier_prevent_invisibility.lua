
modifier_prevent_invisibility = class({})

--------------------------------------------------------------------------------

function modifier_prevent_invisibility:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_prevent_invisibility:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_prevent_invisibility:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end

--------------------------------------------------------------------------------

--[[
function modifier_prevent_invisibility:GetEffectName()
	return "particles/creature_true_sight.vpcf"
end

--------------------------------------------------------------------------------

function modifier_prevent_invisibility:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
]]

--------------------------------------------------------------------------------

function modifier_prevent_invisibility:CheckState()
	local state = {}
	if IsServer() then
		state[ MODIFIER_STATE_INVISIBLE ] = false
	end

	return state
end

--------------------------------------------------------------------------------
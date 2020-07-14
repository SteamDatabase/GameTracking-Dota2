modifier_bonus_room_start = class({})

--------------------------------------------------------------------------------

function modifier_bonus_room_start:IsHidden()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_bonus_room_start:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_bonus_room_start:GetTexture()
	return "buyback"
end

-- -----------------------------------------------------------------------------------------

-- function modifier_bonus_room_start:ShouldUseOverheadOffset()
-- 	return true
-- end

-- -----------------------------------------------------------------------------------------

-- function modifier_bonus_room_start:GetEffectAttachType()
-- 	return PATTACH_OVERHEAD_FOLLOW
-- end

-- -----------------------------------------------------------------------------------------

-- function modifier_bonus_room_start:GetEffectName()
-- 	return "particles/generic_gameplay/generic_silenced.vpcf"
-- end

--------------------------------------------------------------------------------

function modifier_bonus_room_start:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10001
end

--------------------------------------------------------------------------------

function modifier_bonus_room_start:CheckState()
	local state = {}

	if IsServer() then
		state[MODIFIER_STATE_SILENCED] = true
		state[MODIFIER_STATE_MUTED] = true
	end
	
	return state
end



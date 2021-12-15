
modifier_fat_golem_burst_debuff = class({})

----------------------------------------------------------------------------------------

function modifier_fat_golem_burst_debuff:IsDebuff()
	return true
end

----------------------------------------------------------------------------------------

function modifier_fat_golem_burst_debuff:GetEffectName()
	return "particles/generic_gameplay/generic_silenced.vpcf"; 
end

----------------------------------------------------------------------------------------

function modifier_fat_golem_burst_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

----------------------------------------------------------------------------------------

function modifier_fat_golem_burst_debuff:ShouldUseOverheadOffset()
	return true 
end

----------------------------------------------------------------------------------------

function modifier_fat_golem_burst_debuff:CheckState()
	local state =
	{
		[ MODIFIER_STATE_SILENCED ] = true,
	}

	return state
end

----------------------------------------------------------------------------------------

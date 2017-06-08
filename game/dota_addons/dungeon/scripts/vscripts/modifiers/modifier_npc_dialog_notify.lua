modifier_npc_dialog_notify = class({})

--------------------------------------------------------------------------------

function modifier_npc_dialog_notify:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_npc_dialog_notify:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_npc_dialog_notify:GetEffectName()
	return "particles/generic_gameplay/generic_has_quest.vpcf"
end

--------------------------------------------------------------------------------

function modifier_npc_dialog_notify:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_npc_dialog_notify:ShouldUseOverheadOffset()
	return true
end

--------------------------------------------------------------------------------

function modifier_npc_dialog_notify:CheckState()
	local state = 
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
	return state
end
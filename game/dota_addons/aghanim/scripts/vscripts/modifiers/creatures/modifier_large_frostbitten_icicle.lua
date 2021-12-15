modifier_large_frostbitten_icicle = class({})

------------------------------------------------------------------

function modifier_large_frostbitten_icicle:OnCreated( kv )
end

function modifier_large_frostbitten_icicle:GetStatusEffectName()  
	return "particles/status_fx/status_effect_wyvern_cold_embrace.vpcf"
end

--------------------------------------------------------------------------------

function modifier_large_frostbitten_icicle:CheckState()
	local state = {}
	state[MODIFIER_STATE_STUNNED] = true
	state[MODIFIER_STATE_FROZEN] = true
	
	return state
end





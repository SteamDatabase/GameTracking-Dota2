modifier_weaver_bug_bomb = class({})

------------------------------------------------------------------

function modifier_weaver_bug_bomb:OnCreated( kv )
end

function modifier_weaver_bug_bomb:GetStatusEffectName()  
	return "particles/status_fx/status_effect_wyvern_cold_embrace.vpcf"
end

--------------------------------------------------------------------------------

function modifier_weaver_bug_bomb:CheckState()
	local state = {}
	state[MODIFIER_STATE_STUNNED] = true
	
	return state
end

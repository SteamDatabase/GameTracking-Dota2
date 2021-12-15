modifier_boss_arc_warden_meteor = class({})

--------------------------------------------------------------------------------

function modifier_boss_arc_warden_meteor:IsHidden()
	return true
end

------------------------------------------------------------------

function modifier_boss_arc_warden_meteor:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_arc_warden_meteor:CheckState()
	local state = 
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
	
	return state
end



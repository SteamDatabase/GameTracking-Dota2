modifier_boss_intro = class({})

--------------------------------------------------------------------------------

function modifier_boss_intro:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_boss_intro:CheckState()
	local state = 
	{
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
	
	return state
end



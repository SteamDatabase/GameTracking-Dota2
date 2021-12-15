modifier_boss_intro = class({})

--------------------------------------------------------------------------------

function modifier_boss_intro:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_boss_intro:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_intro:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10001
end

--------------------------------------------------------------------------------

function modifier_boss_intro:CheckState()
	local state = 
	{
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	}
	
	return state
end



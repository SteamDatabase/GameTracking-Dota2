
modifier_hero_selecting_mount = class({})

--------------------------------------------------------------------------------

function modifier_hero_selecting_mount:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_hero_selecting_mount:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_hero_selecting_mount:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end

--------------------------------------------------------------------------------

function modifier_hero_selecting_mount:CheckState()
	local state =
	{
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
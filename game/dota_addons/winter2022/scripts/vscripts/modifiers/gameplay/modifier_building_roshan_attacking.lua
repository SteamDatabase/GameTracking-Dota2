
modifier_building_roshan_attacking = class({})

--------------------------------------------------------------------------------

function modifier_building_roshan_attacking:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_building_roshan_attacking:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_building_roshan_attacking:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end

--------------------------------------------------------------------------------

function modifier_building_roshan_attacking:CheckState()
	if IsServer() == false then
		return
	end

	local state =
	{
		[MODIFIER_STATE_INVULNERABLE] = false,
	}

	return state
end

-------------------------------------------------------------------------------

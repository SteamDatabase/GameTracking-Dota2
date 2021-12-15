
modifier_creature_phoenix_passive = class({})

-----------------------------------------------------------------------------------------

function modifier_creature_phoenix_passive:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_creature_phoenix_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_creature_phoenix_passive:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end

--------------------------------------------------------------------------------

function modifier_creature_phoenix_passive:OnCreated( kv )
	if IsServer() then
		self:GetParent().bAbsoluteNoCC = true -- keep this for the modifier blacklist
	end
end

-----------------------------------------------------------------------------------------

function modifier_creature_phoenix_passive:CheckState()
	local state =
	{
		[MODIFIER_STATE_HEXED] = false,
		[MODIFIER_STATE_ROOTED] = false,
		[MODIFIER_STATE_SILENCED] = false,
		[MODIFIER_STATE_STUNNED] = false,
		[MODIFIER_STATE_FROZEN] = false,
		[MODIFIER_STATE_FEARED] = false,

		-- absolute_no_cc was preventing Phoenix from being motion controlled by his own Dive
		--[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
	}

	return state
end

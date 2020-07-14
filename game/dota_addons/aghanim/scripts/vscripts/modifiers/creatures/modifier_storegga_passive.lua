
modifier_storegga_passive = class({})

-----------------------------------------------------------------------------------------

function modifier_storegga_passive:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_storegga_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_storegga_passive:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end

-----------------------------------------------------------------------------------------

function modifier_storegga_passive:CheckState()
	local state =
	{
		[MODIFIER_STATE_HEXED] = false,
		[MODIFIER_STATE_ROOTED] = false,
		[MODIFIER_STATE_SILENCED] = false,
		[MODIFIER_STATE_STUNNED] = false,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_FROZEN] = false,
		[MODIFIER_STATE_FEARED] = false,
		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
	}
	return state
end

--------------------------------------------------------------------------------

function modifier_storegga_passive:OnCreated( kv )
	if IsServer() then
		self:GetParent().bAbsoluteNoCC = true
	end
end

-----------------------------------------------------------------------------------------

function modifier_storegga_passive:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_REDUCTION_PERCENTAGE,
	}
	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_storegga_passive:GetModifierMoveSpeedReductionPercentage( params )
	return 0
end
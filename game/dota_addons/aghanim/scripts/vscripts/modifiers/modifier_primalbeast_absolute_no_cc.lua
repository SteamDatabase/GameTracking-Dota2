
modifier_primalbeast_absolute_no_cc = class({})

--------------------------------------------------------------------------------

function modifier_primalbeast_absolute_no_cc:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_primalbeast_absolute_no_cc:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_primalbeast_absolute_no_cc:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end

--------------------------------------------------------------------------------

function modifier_primalbeast_absolute_no_cc:OnCreated( kv )
	if IsServer() then
		self:GetParent().bAbsoluteNoCC = true
	end
end

--------------------------------------------------------------------------------

function modifier_primalbeast_absolute_no_cc:CheckState()


	if IsServer() then	
		local state =
		{
			[MODIFIER_STATE_HEXED] = false,
			[MODIFIER_STATE_ROOTED] = false,
			[MODIFIER_STATE_SILENCED] = false,
			[MODIFIER_STATE_STUNNED] = false,
			[MODIFIER_STATE_FROZEN] = false,
			[MODIFIER_STATE_FEARED] = false,
			[MODIFIER_STATE_TAUNTED] = false,
			[MODIFIER_STATE_DISARMED] = false,
		}

		return state
	end
end

--------------------------------------------------------------------------------

function modifier_primalbeast_absolute_no_cc:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_REDUCTION_PERCENTAGE,
	}

	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_primalbeast_absolute_no_cc:GetModifierMoveSpeedReductionPercentage( params )
	return 0
end


--------------------------------------------------------------------------------

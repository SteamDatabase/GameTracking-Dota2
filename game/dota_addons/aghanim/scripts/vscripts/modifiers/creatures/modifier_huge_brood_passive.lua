
modifier_huge_brood_passive = class({})

-----------------------------------------------------------------------------------------

function modifier_huge_brood_passive:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_huge_brood_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_huge_brood_passive:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end

--------------------------------------------------------------------------------

function modifier_huge_brood_passive:OnCreated( kv )
	self.status_resistance = self:GetAbility():GetSpecialValueFor( "status_resistance" )
end


-----------------------------------------------------------------------------------------

function modifier_huge_brood_passive:CheckState()
	local state =
	{
		[MODIFIER_STATE_FEARED] = false,
		--[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
		--[MODIFIER_STATE_UNSLOWABLE] = true,
	}

	return state
end

-----------------------------------------------------------------------------------------

function modifier_huge_brood_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_huge_brood_passive:GetModifierStatusResistanceStacking( params )
	return self.status_resistance
end

--------------------------------------------------------------------------------

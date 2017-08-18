modifier_explorer_mode = class({})

--------------------------------------------------------------------------------

function modifier_explorer_mode:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_explorer_mode:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_explorer_mode:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_explorer_mode:GetModifierTotalDamageOutgoing_Percentage( params )
	return -EXPLORER_MODE_INCOMING_DAMAGE_REDUCTION
end

--------------------------------------------------------------------------------

function modifier_explorer_mode:GetModifierExtraHealthPercentage( params )
	return -( EXPLORER_MODE_ENEMY_HP_REDUCTION / 100 )
end
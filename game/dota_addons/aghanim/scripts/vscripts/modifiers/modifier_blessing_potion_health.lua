modifier_blessing_potion_health = class({})

--------------------------------------------------------------------------------

function modifier_blessing_potion_health:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessing_potion_health:GetHealthRestorePercentBonus( params )
	return self:GetStackCount()
end

--------------------------------------------------------------------------------
function modifier_blessing_potion_health:IsPermanent()
	return true
end
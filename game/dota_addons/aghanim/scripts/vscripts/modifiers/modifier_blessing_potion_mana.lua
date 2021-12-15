modifier_blessing_potion_mana = class({})

--------------------------------------------------------------------------------

function modifier_blessing_potion_mana:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessing_potion_mana:GetManaRestorePercentBonus()
	return self:GetStackCount()
end


--------------------------------------------------------------------------------
function modifier_blessing_potion_mana:IsPermanent()
	return true
end
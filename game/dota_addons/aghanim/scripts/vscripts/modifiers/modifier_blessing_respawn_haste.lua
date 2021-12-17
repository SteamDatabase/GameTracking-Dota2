modifier_blessing_respawn_haste = class({})

--------------------------------------------------------------------------------

function modifier_blessing_respawn_haste:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessing_respawn_haste:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end


-----------------------------------------------------------------------------------------

function modifier_blessing_respawn_haste:IsPermanent()
	return true
end
--------------------------------------------------------------------------------

function modifier_blessing_respawn_haste:GetModifierMoveSpeedBonus_Percentage()
	if self:GetParent():HasModifier("modifier_invulnerable") and self:GetParent():HasModifier("modifier_omninight_guardian_angel") and self:GetParent():HasModifier("modifier_phased") then
		return self:GetStackCount()
	end
	return 0
end

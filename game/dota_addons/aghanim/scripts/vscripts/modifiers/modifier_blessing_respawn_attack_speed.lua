modifier_blessing_respawn_attack_speed = class({})

----------------------------------------

function modifier_blessing_respawn_attack_speed:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessing_respawn_attack_speed:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_respawn_attack_speed:GetModifierAttackSpeedBonus_Constant( params )
	if self:GetParent() == nil or self:GetParent().FindModifierByName == nil then
		return 0
	end

	if self:GetParent():FindModifierByName("modifier_invulnerable") and self:GetParent():FindModifierByName("modifier_omninight_guardian_angel") and self:GetParent():FindModifierByName("modifier_phased")  then
		return self:GetStackCount()
	end
	
	return 0
end

--------------------------------------------------------------------------------
function modifier_blessing_respawn_attack_speed:IsPermanent()
	return true
end
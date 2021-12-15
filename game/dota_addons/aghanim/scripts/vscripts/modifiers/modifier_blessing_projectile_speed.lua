modifier_blessing_projectile_speed = class({})

--------------------------------------------------------------------------------

function modifier_blessing_projectile_speed:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessing_projectile_speed:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_projectile_speed:GetModifierProjectileSpeedBonus( params )
	if self:GetParent():IsRangedAttacker() then
		return self:GetStackCount()
	end

	return 0
end

--------------------------------------------------------------------------------
function modifier_blessing_projectile_speed:IsPermanent()
	return true
end
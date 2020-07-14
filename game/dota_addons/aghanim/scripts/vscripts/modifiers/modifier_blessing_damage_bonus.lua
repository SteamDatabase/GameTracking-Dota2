require( "modifiers/modifier_blessing_base" )

modifier_blessing_damage_bonus = class( modifier_blessing_base )

----------------------------------------

function modifier_blessing_damage_bonus:OnBlessingCreated( kv )
	self.bonus_damage = kv.bonus_damage
end

--------------------------------------------------------------------------------

function modifier_blessing_damage_bonus:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_damage_bonus:GetModifierPreAttack_BonusDamage( params )
	if self:GetParent() ~= nil and self:GetParent():IsNull() == false then
		return self.bonus_damage * self:GetParent():GetLevel()
	end

	print( 'WARNING: modifier_blessing_damage_bonus:GetModifierPreAttack_BonusDamage - parent not found - returning 0' )
	return 0
end

--------------------------------------------------------------------------------

function modifier_blessing_damage_bonus:OnTooltip( params )
	return self.bonus_damage
end

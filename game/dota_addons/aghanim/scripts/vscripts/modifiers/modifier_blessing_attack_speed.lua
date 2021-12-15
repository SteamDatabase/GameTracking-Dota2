require( "modifiers/modifier_blessing_base" )

modifier_blessing_attack_speed = class( modifier_blessing_base )

----------------------------------------

function modifier_blessing_attack_speed:OnBlessingCreated( kv )
	self.bonus_attack_speed = kv.bonus_attack_speed
end

--------------------------------------------------------------------------------
function modifier_blessing_attack_speed:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessing_attack_speed:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_attack_speed:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end

modifier_item_sign_of_the_arachnid_effect = class({})

----------------------------------------

function modifier_item_sign_of_the_arachnid_effect:GetTexture()
	return "item_sign_of_the_arachnid"
end

----------------------------------------

function modifier_item_sign_of_the_arachnid_effect:OnCreated( kv )
	self.bonus_move_speed_pct = self:GetAbility():GetSpecialValueFor( "bonus_move_speed_pct" )
	self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
end

----------------------------------------

function modifier_item_sign_of_the_arachnid_effect:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

----------------------------------------

function modifier_item_sign_of_the_arachnid_effect:GetModifierMoveSpeedBonus_Percentage( params )
	return self.bonus_move_speed_pct
end

----------------------------------------

function modifier_item_sign_of_the_arachnid_effect:GetModifierAttackSpeedBonus_Constant( params )
	return self.attack_speed
end

modifier_beastmaster_statue_boar_poison_effect = class({})

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_boar_poison_effect:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_boar_poison_effect:OnCreated( kv )
	self.movement_speed = self:GetAbility():GetSpecialValueFor( "movement_speed" )
	self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_boar_poison_effect:OnRefresh( kv )
	self.movement_speed = self:GetAbility():GetSpecialValueFor( "movement_speed" )
	self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_boar_poison_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_boar_poison_effect:GetModifierMoveSpeedBonus_Percentage( params )
	return self.movement_speed
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_boar_poison_effect:GetModifierAttackSpeedBonus_Constant( params )
	return self.attack_speed
end

--------------------------------------------------------------------------------

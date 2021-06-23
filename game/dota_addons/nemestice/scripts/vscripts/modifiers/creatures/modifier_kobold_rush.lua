
modifier_kobold_rush = class({})

-----------------------------------------------------------------------------------------

function modifier_kobold_rush:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_kobold_rush:OnCreated( kv )
	self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
	self.model_scale = self:GetAbility():GetSpecialValueFor( "mode_scale" )

	if IsServer() then
		EmitSoundOn( "Spring2021.Kobold.Rush", self:GetParent() )
	end
end

--------------------------------------------------------------------------------

function modifier_kobold_rush:GetEffectName()
    return "particles/items2_fx/mask_of_madness.vpcf"
end

--------------------------------------------------------------------------------

function modifier_kobold_rush:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}

	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_kobold_rush:GetModifierMoveSpeedBonus_Constant( params )
	return self.move_speed
end

-----------------------------------------------------------------------------------------

function modifier_kobold_rush:GetModifierAttackSpeedBonus_Constant( params )
	return self.attack_speed
end

-----------------------------------------------------------------------------------------

function modifier_kobold_rush:GetModifierModelScale( params )
	return self.model_scale
end



if modifier_bucket_soldier_attack_debuff == nil then
	modifier_bucket_soldier_attack_debuff = class( {} ) 
end

----------------------------------------------------------------------------------------

function modifier_bucket_soldier_attack_debuff:IsDebuff()
	return true
end

-----------------------------------------------------------------------------

function modifier_bucket_soldier_attack_debuff:GetEffectName()
	return "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf"
end

-----------------------------------------------------------------------------

function modifier_bucket_soldier_attack_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_snapfire_slow.vpcf"
end

-----------------------------------------------------------------------------

function modifier_bucket_soldier_attack_debuff:OnCreated( kv )
	if self:GetAbility() then
		self.movement_speed_slow = self:GetAbility():GetSpecialValueFor( "movement_speed_slow" )
		self.attack_speed_slow = self:GetAbility():GetSpecialValueFor( "attack_speed_slow" )
	else
		return
	end

	if IsServer() then
		--EmitSoundOn( "FrostbittenShaman.FrostArmor.Debuff", self:GetParent() )
	end
end

-----------------------------------------------------------------------------

function modifier_bucket_soldier_attack_debuff:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

-----------------------------------------------------------------------------

function modifier_bucket_soldier_attack_debuff:GetModifierMoveSpeedBonus_Percentage( params )
	return self.movement_speed_slow
end

-----------------------------------------------------------------------------

function modifier_bucket_soldier_attack_debuff:GetModifierAttackSpeedBonus_Constant( params )
	return self.attack_speed_slow
end

-----------------------------------------------------------------------------


modifier_lifestealer_enraged = class({})

-----------------------------------------------------------------------------------------

function modifier_lifestealer_enraged:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_lifestealer_enraged:GetStatusEffectName()
	return "particles/status_fx/status_effect_life_stealer_rage.vpcf"
end

-----------------------------------------------------------------------------------------

function modifier_lifestealer_enraged:StatusEffectPriority()
	return 60
end

-----------------------------------------------------------------------------------------

function modifier_lifestealer_enraged:OnCreated( kv )
	self.enrage_movespeed_bonus = self:GetAbility():GetSpecialValueFor( "enrage_movespeed_bonus" )
	self.enrage_attack_speed_bonus = self:GetAbility():GetSpecialValueFor( "enrage_attack_speed_bonus" )
	self.enrage_model_scale_bonus = self:GetAbility():GetSpecialValueFor( "enrage_model_scale_bonus" )

	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_life_stealer/life_stealer_rage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), false )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )

		EmitSoundOn( "Lifestealer.Enraged.Activate", self:GetParent() )

		local hEnragedPulseAbility = self:GetParent():FindAbilityByName( "aghsfort_lifestealer_enraged_pulse" )

		if hEnragedPulseAbility then
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = hEnragedPulseAbility:entindex()
			})
		end
	end
end

-----------------------------------------------------------------------------------------

function modifier_lifestealer_enraged:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}

	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_lifestealer_enraged:GetModifierMoveSpeedBonus_Constant( params )
	return self.enrage_movespeed_bonus
end

-----------------------------------------------------------------------------------------

function modifier_lifestealer_enraged:GetModifierAttackSpeedBonus_Constant( params )
	return self.enrage_attack_speed_bonus
end

-----------------------------------------------------------------------------------------

function modifier_lifestealer_enraged:GetModifierModelScale( params )
	return self.enrage_model_scale_bonus
end

-----------------------------------------------------------------------------------------

function modifier_lifestealer_enraged:CheckState()
	local state = {}

	if IsServer()  then
		state[ MODIFIER_STATE_MAGIC_IMMUNE ] = true
	end

	return state
end

-----------------------------------------------------------------------------------------

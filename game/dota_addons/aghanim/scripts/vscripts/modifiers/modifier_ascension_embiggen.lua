
modifier_ascension_embiggen = class({})


----------------------------------------

function modifier_ascension_embiggen:GetTexture()
	return "events/aghanim/interface/hazard_embiggen"
end

----------------------------------------

function modifier_ascension_embiggen:OnCreated( kv )
	self.model_scale_per_stack = self:GetAbility():GetSpecialValueFor( "model_scale_per_stack" )
	local nMaxModelScaleIncreases = self:GetAbility():GetSpecialValueFor( "max_model_scale_increases" )
	self.nMaxModelScaleGain = self.model_scale_per_stack * nMaxModelScaleIncreases
	self.turn_rate_slow_pct = self:GetAbility():GetSpecialValueFor( "turn_rate_slow_pct" )
	self.attack_speed_slow = self:GetAbility():GetSpecialValueFor( "attack_speed_slow" )

	if IsServer() then
		if self.nOverheadFXIndex == nil then
			self.nOverheadFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControlEnt( self.nOverheadFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )

			--iIndex, bDestroyImmediatly, bStatusEffect, iPriority, bHeroEffect, bOverheadEffect )
			self:AddParticle( self.nOverheadFXIndex, false, false, -1, true, true )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_ascension_embiggen:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_ascension_embiggen:GetModifierModelScale( params )
	local flScale = self.model_scale_per_stack * self:GetStackCount() 
	if flScale < self.nMaxModelScaleGain then
		return flScale
	else
		return self.nMaxModelScaleGain
	end
end

--------------------------------------------------------------------------------

function modifier_ascension_embiggen:GetModifierTurnRate_Percentage( params )
	return -self.turn_rate_slow_pct * self:GetStackCount()
end

--------------------------------------------------------------------------------

function modifier_ascension_embiggen:GetModifierAttackSpeedBonus_Constant( params )
	return -self.attack_speed_slow * self:GetStackCount()
end 

--------------------------------------------------------------------------------

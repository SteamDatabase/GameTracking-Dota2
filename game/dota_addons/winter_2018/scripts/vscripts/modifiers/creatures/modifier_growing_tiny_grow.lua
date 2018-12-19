
modifier_growing_tiny_grow = class({})

--------------------------------------------------------------------------------

function modifier_growing_tiny_grow:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_growing_tiny_grow:OnCreated( kv )
	self.bonus_movement_speed = self:GetAbility():GetSpecialValueFor( "bonus_movement_speed" )
	self.model_scale_modifier = self:GetAbility():GetSpecialValueFor( "model_scale_modifier" )
	self.outgoing_damage_percentage = self:GetAbility():GetSpecialValueFor( "outgoing_damage_percentage" )
	self.extra_health_bonus_percentage = self:GetAbility():GetSpecialValueFor( "extra_health_bonus_percentage" )
	self.max_stack_count = self:GetAbility():GetSpecialValueFor( "max_stack_count" )

	if IsServer() then 
			self:SetStackCount(0)
	end
end

--------------------------------------------------------------------------------

function modifier_growing_tiny_grow:OnAttackLanded(params) 
	if IsServer() then
		if params.attacker ~= self:GetParent() then
			return
		end

		if params.target:IsBuilding() == false then
			return
		end

		if self:GetStackCount() <= self.max_stack_count then
			self:IncrementStackCount()
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_tiny/tiny_transform.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		else
			return
		end
	end
end

--------------------------------------------------------------------------------

function modifier_growing_tiny_grow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}

	return funcs
end


--------------------------------------------------------------------------------

function modifier_growing_tiny_grow:GetModifierMoveSpeedBonus_Percentage( params )
	return self.bonus_movement_speed * self:GetStackCount()
end

--------------------------------------------------------------------------------

function modifier_growing_tiny_grow:GetModifierModelScale( params )
	return self.model_scale_modifier * self:GetStackCount() 
end
--------------------------------------------------------------------------------

function modifier_growing_tiny_grow:GetModifierDamageOutgoing_Percentage( params )
	return self.outgoing_damage_percentage * self:GetStackCount() 
end
--------------------------------------------------------------------------------

function modifier_growing_tiny_grow:GetModifierExtraHealthPercentage( params )
	return self.extra_health_bonus_percentage * self:GetStackCount() 
end

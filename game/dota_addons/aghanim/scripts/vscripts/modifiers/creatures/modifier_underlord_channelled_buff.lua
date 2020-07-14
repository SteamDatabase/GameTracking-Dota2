
modifier_underlord_channelled_buff = class({})

-----------------------------------------------------------------------------

function modifier_underlord_channelled_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

-----------------------------------------------------------------------------

function modifier_underlord_channelled_buff:GetEffectName()
	return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf"
end

-----------------------------------------------------------------------------

function modifier_underlord_channelled_buff:OnCreated( kv )
	if not self:GetAbility() then
		return
	end

	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	self.bonus_movement_speed = self:GetAbility():GetSpecialValueFor( "bonus_movement_speed" )
	self.modelscale = self:GetAbility():GetSpecialValueFor( "modelscale" )

	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pugna/pugna_life_drain.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex , true, false, 0, false, false )	
	end
end

-----------------------------------------------------------------------------

function modifier_underlord_channelled_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}

	return funcs
end


-----------------------------------------------------------------------------

function modifier_underlord_channelled_buff:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end

-----------------------------------------------------------------------------

function modifier_underlord_channelled_buff:GetModifierMoveSpeedBonus_Percentage( params )
	return self.bonus_movement_speed
end

-----------------------------------------------------------------------------

function modifier_underlord_channelled_buff:GetModifierModelScale( params )
	return self.modelscale
end

-----------------------------------------------------------------------------

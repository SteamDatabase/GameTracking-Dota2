
modifier_frostbitten_shaman_buff = class({})

-----------------------------------------------------------------------------

function modifier_frostbitten_shaman_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

-----------------------------------------------------------------------------

function modifier_frostbitten_shaman_buff:GetEffectName()
	return "particles/act_2/frostbitten_shaman_repel_buff.vpcf"
end

-----------------------------------------------------------------------------

function modifier_frostbitten_shaman_buff:GetStatusEffectName()  
	return "particles/status_fx/status_effect_repel.vpcf"
end

-----------------------------------------------------------------------------

function modifier_frostbitten_shaman_buff:OnCreated( kv )
	if not self:GetAbility() then
		return
	end

	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	self.bonus_movement_speed = self:GetAbility():GetSpecialValueFor( "bonus_movement_speed" )
	self.modelscale = self:GetAbility():GetSpecialValueFor( "modelscale" )
	
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/act_2/frostbitten_shaman_buff.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex , true, false, 0, false, false )
	end
end

-----------------------------------------------------------------------------

function modifier_frostbitten_shaman_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}	
	return funcs
end


-----------------------------------------------------------------------------

function modifier_frostbitten_shaman_buff:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end

-----------------------------------------------------------------------------

function modifier_frostbitten_shaman_buff:GetModifierMoveSpeedBonus_Percentage( params )
	return self.bonus_movement_speed
end

-----------------------------------------------------------------------------

function modifier_frostbitten_shaman_buff:GetModifierModelScale( params )
	return self.modelscale
end

-----------------------------------------------------------------------------

function modifier_frostbitten_shaman_buff:CheckState()
	local state =
	{
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end

-----------------------------------------------------------------------------


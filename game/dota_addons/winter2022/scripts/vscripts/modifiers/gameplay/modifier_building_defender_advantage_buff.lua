
modifier_building_defender_advantage_buff = class({})

--------------------------------------------------------------------------------

function modifier_building_defender_advantage_buff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_building_defender_advantage_buff:Init() 
	if self.bInited then
		return true
	end
	if self:GetAbility() == nil then
		return false
	end
	self.bInited = true
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.bonus_magic_resist = self:GetAbility():GetSpecialValueFor( "bonus_magic_resist" )
	self.bonus_status_resist = self:GetAbility():GetSpecialValueFor( "bonus_status_resist" )
	self.bonus_hp_regen = self:GetAbility():GetSpecialValueFor( "bonus_hp_regen" )
	self.bonus_move_speed_percent = self:GetAbility():GetSpecialValueFor( "bonus_move_speed_percent" )
	self.bonus_damage_outgoing_percent = self:GetAbility():GetSpecialValueFor( "bonus_damage_outgoing_percent" )
	self.bonus_spell_amplify_percent = self:GetAbility():GetSpecialValueFor( "bonus_spell_amplify_percent" )
	self.model_scale = self:GetAbility():GetSpecialValueFor( "model_scale" )

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_death_prophet/death_prophet_spiritsiphon.vpcf", PATTACH_CUSTOMORIGIN, self.hMeteor )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
	ParticleManager:SetParticleControl( nFXIndex, 5, Vector( 999, 0, 0 ) ) 
	--ParticleManager:SetParticleFoWProperties( nFXIndex, 0, 1, 50.f )
	self:AddParticle( nFXIndex, false, false, -1, false, true )

	if IsServer() then
		self:GetParent():EmitSound( "CandyBucket.Defender.Buff" )
	end
end

--------------------------------------------------------------------------------

function modifier_building_defender_advantage_buff:OnCreated( kv )
	self:Init()
end

--------------------------------------------------------------------------------

function modifier_building_defender_advantage_buff:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound( "CandyBucket.Defender.Buff" )
	end
end

--------------------------------------------------------------------------------

function modifier_building_defender_advantage_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_BONUSDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_building_defender_advantage_buff:GetModifierPhysicalArmorBonus( params )
	if not self:Init() then return 0 end
	return self.bonus_armor
end

--------------------------------------------------------------------------------

function modifier_building_defender_advantage_buff:GetModifierMagicalResistanceBonus( params )
	if not self:Init() then return 0 end
	return self.bonus_magic_resist
end

--------------------------------------------------------------------------------

function modifier_building_defender_advantage_buff:GetModifierStatusResistanceStacking( params )
	if not self:Init() then return 0 end
	return self.bonus_status_resist
end

--------------------------------------------------------------------------------

function modifier_building_defender_advantage_buff:GetModifierConstantHealthRegen( params )
	if not self:Init() then return 0 end
	return self.bonus_hp_regen
end

--------------------------------------------------------------------------------

function modifier_building_defender_advantage_buff:GetModifierMoveSpeedBonus_Percentage( params )
	if not self:Init() then return 0 end
	return self.bonus_move_speed_percent
end

--------------------------------------------------------------------------------

function modifier_building_defender_advantage_buff:GetModifierBonusDamageOutgoing_Percentage( params )
	if not self:Init() then return 0 end
	return self.bonus_damage_outgoing_percent
end

--------------------------------------------------------------------------------

function modifier_building_defender_advantage_buff:GetModifierSpellAmplify_Percentage( params )
	if not self:Init() then return 0 end
	return self.bonus_spell_amplify_percent
end

--------------------------------------------------------------------------------

function modifier_building_defender_advantage_buff:GetModifierModelScale( params )
	if not self:Init() then return 0 end
	return self.model_scale
end
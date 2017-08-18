modifier_amoeba_boss_passive = class({})

_G.bInit = false
_G.hBossAmoeba = nil
-----------------------------------------------------------------------------------------

function modifier_amoeba_boss_passive:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_amoeba_boss_passive:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_amoeba_boss_passive:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

-----------------------------------------------------------------------------------------

function modifier_amoeba_boss_passive:CheckState()
	local state = {}
	if IsServer() then
		if self:GetParent() == _G.hBossAmoeba then
			state[MODIFIER_STATE_STUNNED] = false
			state[MODIFIER_STATE_HEXED] = false
			state[MODIFIER_STATE_ROOTED] = false
			state[MODIFIER_STATE_SILENCED] = false
		end
	end
	return state
end

-----------------------------------------------------------------------------------------

function modifier_amoeba_boss_passive:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_amoeba_boss_passive:OnCreated( kv )
	self.model_scale_per_stack = self:GetAbility():GetSpecialValueFor( "model_scale_per_stack" )
	self.move_speed_loss_per_stack = self:GetAbility():GetSpecialValueFor( "move_speed_loss_per_stack" )
	self.base_attack_time_per_stack = self:GetAbility():GetSpecialValueFor( "base_attack_time_per_stack" )
	self.attack_damage_per_stack = self:GetAbility():GetSpecialValueFor( "attack_damage_per_stack" )
	self.damage_per_amoeba = self:GetAbility():GetSpecialValueFor( "damage_per_amoeba" )
	self.bonus_hp_per_stack = self:GetAbility():GetSpecialValueFor( "bonus_hp_per_stack" )
	self.bonus_attack_range_per_stack = self:GetAbility():GetSpecialValueFor( "bonus_attack_range_per_stack" )
	self.armor_per_stack = self:GetAbility():GetSpecialValueFor( "armor_per_stack" )
	self.hull_radius_per_stack = self:GetAbility():GetSpecialValueFor( "hull_radius_per_stack" )
	self.starting_stacks = self:GetAbility():GetSpecialValueFor( "starting_stacks" )

	self.projectile_speed = self:GetAbility():GetSpecialValueFor( "projectile_speed" )

	if IsServer() then
		self.flAccumDamage = 0
		if _G.bInit == false and self:GetParent():GetUnitName() == "npc_dota_creature_amoeba_boss" then
			_G.bInit = true
			_G.hBossAmoeba = self:GetParent()
			self:SetStackCount( self.starting_stacks )
		end
	
	end
end


-----------------------------------------------------------------------------------------

function modifier_amoeba_boss_passive:OnStackCountChanged( nOldCount )
	if IsServer() then

		self:GetParent():SetHullRadius( 8.0 + self:GetStackCount() * self.hull_radius_per_stack )
		FindClearSpaceForUnit( self:GetParent(), self:GetParent():GetOrigin(), false )

		if self:GetStackCount() <= 50 and self:GetStackCount() > 25 and self:GetParent() ~= _G.hBossAmoeba then
			self:GetParent():SetRenderColor( 0, 255, 0 )
			self:GetParent():SetMaxHealth( 7500 )
			self:GetParent():Heal( 7500, self )
		end
		if self:GetStackCount() == 1 then
			self:GetParent():SetRenderColor( 0, 0, 255 )
		end
		return 0
	end
end

-----------------------------------------------------------------------------------------

function modifier_amoeba_boss_passive:GetModifierModelScale( params )
	if self:GetStackCount() > 50 then
		return 750
	end
	if self:GetStackCount() <= 50 and self:GetStackCount() > 25 then
		return 300
	end

	return 0
end

-----------------------------------------------------------------------------------------

function modifier_amoeba_boss_passive:GetModifierMoveSpeedOverride( params )
	return 100
end

-----------------------------------------------------------------------------------------

function modifier_amoeba_boss_passive:GetModifierBaseAttackTimeConstant( params )
	return 1.0 + ( self:GetStackCount() * self.base_attack_time_per_stack )
end

-----------------------------------------------------------------------------------------

function modifier_amoeba_boss_passive:GetModifierBaseAttack_BonusDamage( params )
	return self:GetStackCount() * self.attack_damage_per_stack 
end

-----------------------------------------------------------------------------------------

function modifier_amoeba_boss_passive:GetModifierExtraHealthBonus( params )
	return self:GetStackCount() * self.bonus_hp_per_stack
end

-----------------------------------------------------------------------------------------

function modifier_amoeba_boss_passive:GetModifierAttackRangeBonus( params )
	return tonumber( self:GetStackCount() * self.bonus_attack_range_per_stack )
end

--------------------------------------------------------------------------------

function modifier_amoeba_boss_passive:GetModifierPhysicalArmorBonus( params )
	return self:GetStackCount() * self.armor_per_stack
end 

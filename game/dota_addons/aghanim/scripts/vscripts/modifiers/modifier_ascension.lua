
modifier_ascension = class({})

-----------------------------------------------------------------------------------------

function modifier_ascension:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_ascension:IsPurgable()
	return false
end

----------------------------------------

function modifier_ascension:OnCreated( kv )
	self:OnRefresh( kv )
end

----------------------------------------

function modifier_ascension:OnRefresh( kv )
	if self:GetAbility() == nil then
		return
	end

	self.bonus_magic_resist = self:GetAbility():GetSpecialValueFor( "bonus_magic_resist" )
	self.min_bonus_armor = self:GetAbility():GetSpecialValueFor( "min_bonus_armor" )
	self.max_bonus_armor = self:GetAbility():GetSpecialValueFor( "max_bonus_armor" )
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.crit_multiplier = self:GetAbility():GetSpecialValueFor( "crit_multiplier" )
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	self.bonus_hp = self:GetAbility():GetSpecialValueFor( "bonus_hp" )
	self.bonus_cooldown = self:GetAbility():GetSpecialValueFor( "bonus_cooldown" )
	self.bonus_outgoing_damage = self:GetAbility():GetSpecialValueFor( "bonus_outgoing_damage" )	
	self.attack_speed_reduction_pct = self:GetAbility():GetSpecialValueFor( "attack_speed_reduction_pct" )	
	self.move_speed_reduction_pct = self:GetAbility():GetSpecialValueFor( "move_speed_reduction_pct" )	
	self.act_1_modifier = self:GetAbility():GetSpecialValueFor( "act_1_modifier" )	
	self.act_2_modifier = self:GetAbility():GetSpecialValueFor( "act_2_modifier" )	

	self.flActModifier = self:CalculateActModifier()
end

--------------------------------------------------------------------------------

function modifier_ascension:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_REDUCTION_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_REDUCTION_PERCENTAGE,
	}
	return funcs
end

function modifier_ascension:CalculateActModifier()
	if IsServer() == false then
		return 0
	end

	if self:GetParent().Encounter == nil or self:GetParent().Encounter:GetRoom() == nil then
		return 0
	end
	
	local nAct = self:GetParent().Encounter:GetRoom():GetAct()
	if nAct == 1 then
		return self.act_1_modifier
	end
	if nAct == 2 then
		return self.act_2_modifier
	end

	return 0
end

----------------------------------------

function modifier_ascension:GetDepth()
	if IsServer() == false then
		return 0
	end
	if self:GetParent().Encounter == nil then
		return 0
	end
	return self:GetParent().Encounter:GetRoom():GetDepth()
end

--------------------------------------------------------------------------------

function modifier_ascension:GetModifierMagicalResistanceBonus( params )
	return self.bonus_magic_resist
end

--------------------------------------------------------------------------------

function modifier_ascension:GetModifierPhysicalArmorBonus( params )
	if self:GetDepth() == 0 then
		return 0
	end

	local flArmor = Lerp( ( self:GetDepth() - 2.0 ) / ( GameRules.Aghanim:GetMaxDepth() - 2.0 ), self.min_bonus_armor, self.max_bonus_armor )
	return flArmor
end

--------------------------------------------------------------------------------

function modifier_ascension:GetModifierTotalDamageOutgoing_Percentage( params )
	if IsServer() then
		return self.bonus_outgoing_damage + self.flActModifier
	end

	return self.bonus_outgoing_damage
end

--------------------------------------------------------------------------------

function modifier_ascension:GetCritDamage()
	return self.crit_multiplier / 100.0
end

--------------------------------------------------------------------------------

function modifier_ascension:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() then
		local hTarget = params.target
		local hAttacker = params.attacker

		if hTarget and ( hTarget:IsBuilding() == false ) and ( hTarget:IsOther() == false ) and hAttacker and ( hAttacker:GetTeamNumber() ~= hTarget:GetTeamNumber() ) then
			if RandomFloat( 1, 100 ) <= self.crit_chance then -- expose RollPseudoRandomPercentage?
				self.bIsCrit = true
				return self.crit_multiplier
			end
		end
	end

	return 0.0
end

--------------------------------------------------------------------------------

function modifier_ascension:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end

--------------------------------------------------------------------------------

function modifier_ascension:GetModifierExtraHealthPercentage( params )
	if IsServer() then
		return self.bonus_hp + self.flActModifier
	end

	return self.bonus_hp
end

--------------------------------------------------------------------------------

function modifier_ascension:GetModifierPercentageCooldown( params )
	return self.bonus_cooldown
end

--------------------------------------------------------------------------------

function modifier_ascension:GetModifierAttackSpeedReductionPercentage( params )
	if self:GetParent():IsConsideredHero() then
		return self.attack_speed_reduction_pct
	end
	return 100
end

--------------------------------------------------------------------------------

function modifier_ascension:GetModifierMoveSpeedReductionPercentage( params )
	if self:GetParent():IsConsideredHero() then
		return self.move_speed_reduction_pct
	end
	return 100
end

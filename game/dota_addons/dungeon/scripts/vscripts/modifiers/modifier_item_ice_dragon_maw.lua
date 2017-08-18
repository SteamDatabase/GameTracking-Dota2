modifier_item_ice_dragon_maw = class({})

------------------------------------------------------------------------------

function modifier_item_ice_dragon_maw:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_ice_dragon_maw:IsPurgable()
	return false
end

----------------------------------------

function modifier_item_ice_dragon_maw:OnCreated( kv )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.bonus_attack_range = self:GetAbility():GetSpecialValueFor( "bonus_attack_range" )
	self.chance_to_freeze = self:GetAbility():GetSpecialValueFor( "chance_to_freeze" )
	self.freeze_duration = self:GetAbility():GetSpecialValueFor( "freeze_duration" )
end

----------------------------------------

function modifier_item_ice_dragon_maw:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

----------------------------------------

function modifier_item_ice_dragon_maw:GetModifierAttackRangeBonus( params )
	if self:GetParent():IsRangedAttacker() then
		return self.bonus_attack_range
	end
	return 0
end

----------------------------------------

function modifier_item_ice_dragon_maw:GetModifierPreAttack_BonusDamage( params )
	return self.bonus_damage
end

----------------------------------------

function modifier_item_ice_dragon_maw:OnAttackLanded( params )
	if IsServer() then
		local hAttacker = params.attacker
		local hTarget = params.target
		if hAttacker == nil or hAttacker ~= self:GetParent() or hTarget == nil then
			return 0
		end

		if hTarget:IsMagicImmune() == false and hTarget:IsInvulnerable() == false and RollPercentage( self.chance_to_freeze ) then
			hTarget:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_large_frostbitten_icicle", { duration = self.freeze_duration } )
		end
	end
	return 0
end




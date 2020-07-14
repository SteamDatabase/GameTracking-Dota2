modifier_item_winter_embrace = class({})

------------------------------------------------------------------------------

function modifier_item_winter_embrace:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_winter_embrace:IsPurgable()
	return false
end

----------------------------------------

function modifier_item_winter_embrace:OnCreated( kv )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.bonus_intelligence = self:GetAbility():GetSpecialValueFor( "bonus_intelligence" )
	self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" )

end

----------------------------------------

function modifier_item_winter_embrace:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

----------------------------------------

function modifier_item_winter_embrace:GetModifierPhysicalArmorBonus( params )
	return self.bonus_armor
end

----------------------------------------

function modifier_item_winter_embrace:GetModifierBonusStats_Intellect( params )
	return self.bonus_intelligence
end

----------------------------------------

function modifier_item_winter_embrace:OnTakeDamage( params )
	if IsServer() then
		if params.unit ~= self:GetParent() then
			return 0
		end

		local hAttacker = params.attacker
		if hAttacker ~= nil and hAttacker:IsMagicImmune() == false and hAttacker:IsInvulnerable() == false and params.damage_type == DAMAGE_TYPE_PHYSICAL then
			hAttacker:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_ogre_magi_frost_armor_slow", { duration = self.slow_duration} )
		end
	end
	return 0
end


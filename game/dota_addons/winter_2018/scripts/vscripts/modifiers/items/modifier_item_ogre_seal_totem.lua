
modifier_item_ogre_seal_totem = class({})

------------------------------------------------------------------------------

function modifier_item_ogre_seal_totem:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_ogre_seal_totem:IsPurgable()
	return false
end

----------------------------------------

function modifier_item_ogre_seal_totem:OnCreated( kv )
	self.bonus_strength = self:GetAbility():GetSpecialValueFor( "bonus_strength" )
	self.bonus_hp = self:GetAbility():GetSpecialValueFor( "bonus_hp" )
end

--------------------------------------------------------------------------------

function modifier_item_ogre_seal_totem:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_ogre_seal_totem:GetModifierBonusStats_Strength( params )
	return self.bonus_strength
end

--------------------------------------------------------------------------------

function modifier_item_ogre_seal_totem:GetModifierHealthBonus( params )
	return self.bonus_hp
end

--------------------------------------------------------------------------------



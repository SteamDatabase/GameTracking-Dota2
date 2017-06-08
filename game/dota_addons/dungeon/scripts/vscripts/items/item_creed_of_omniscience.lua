item_creed_of_omniscience = class({})
LinkLuaModifier( "modifier_item_creed_of_omniscience", "modifiers/modifier_item_creed_of_omniscience", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_creed_of_omniscience:GetIntrinsicModifierName()
	return "modifier_item_creed_of_omniscience"
end

--------------------------------------------------------------------------------

function item_creed_of_omniscience:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

--------------------------------------------------------------------------------

function item_creed_of_omniscience:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

--------------------------------------------------------------------------------

function item_creed_of_omniscience:IsMuted()	
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end
	if not self:GetCaster():IsHero() then
		return true
	end

	return self.BaseClass.IsMuted( self )
end

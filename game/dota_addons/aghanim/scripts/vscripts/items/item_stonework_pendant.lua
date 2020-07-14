item_stonework_pendant = class({})
LinkLuaModifier( "modifier_item_stonework_pendant", "modifiers/modifier_item_stonework_pendant", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_stonework_pendant:GetIntrinsicModifierName()
	return "modifier_item_stonework_pendant"
end

--------------------------------------------------------------------------------

function item_stonework_pendant:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

--------------------------------------------------------------------------------

function item_stonework_pendant:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level and self:IsInBackpack() == false then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

--------------------------------------------------------------------------------

function item_stonework_pendant:IsMuted()	
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end
	if not self:GetCaster():IsHero() then
		return true
	end
	return self.BaseClass.IsMuted( self )
end

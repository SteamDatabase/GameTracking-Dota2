item_precious_egg = class({})
LinkLuaModifier( "modifier_item_precious_egg", "modifiers/modifier_item_precious_egg", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_precious_egg:GetIntrinsicModifierName()
	return "modifier_item_precious_egg"
end

--------------------------------------------------------------------------------

function item_precious_egg:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

--------------------------------------------------------------------------------

function item_precious_egg:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level and self:IsInBackpack() == false then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

--------------------------------------------------------------------------------

function item_precious_egg:IsMuted()	
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end
	if not self:GetCaster():IsHero() then
		return true
	end
	return self.BaseClass.IsMuted( self )
end

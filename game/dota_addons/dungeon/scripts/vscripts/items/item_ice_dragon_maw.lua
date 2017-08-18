item_ice_dragon_maw = class({})
LinkLuaModifier( "modifier_item_ice_dragon_maw", "modifiers/modifier_item_ice_dragon_maw", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_ice_dragon_maw:GetIntrinsicModifierName()
	return "modifier_item_ice_dragon_maw"
end

--------------------------------------------------------------------------------

function item_ice_dragon_maw:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

--------------------------------------------------------------------------------

function item_ice_dragon_maw:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level and self:IsInBackpack() == false then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

--------------------------------------------------------------------------------

function item_ice_dragon_maw:IsMuted()	
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end
	if not self:GetCaster():IsHero() then
		return true
	end
	return self.BaseClass.IsMuted( self )
end


item_dredged_trident = class({})
LinkLuaModifier( "modifier_item_dredged_trident", "modifiers/modifier_item_dredged_trident", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_dredged_trident:GetIntrinsicModifierName()
	return "modifier_item_dredged_trident"
end

--------------------------------------------------------------------------------

function item_dredged_trident:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

--------------------------------------------------------------------------------

function item_dredged_trident:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level and self:IsInBackpack() == false  then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

--------------------------------------------------------------------------------

function item_dredged_trident:IsMuted()	
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end
	if not self:GetCaster():IsHero() then
		return true
	end
	return self.BaseClass.IsMuted( self )
end

--------------------------------------------------------------------------------


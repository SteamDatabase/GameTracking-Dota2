item_bogduggs_baldric = class({})
LinkLuaModifier( "modifier_item_bogduggs_baldric", "modifiers/modifier_item_bogduggs_baldric", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_bogduggs_baldric:GetIntrinsicModifierName()
	return "modifier_item_bogduggs_baldric"
end

--------------------------------------------------------------------------------

function item_bogduggs_baldric:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

--------------------------------------------------------------------------------

function item_bogduggs_baldric:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level and self:IsInBackpack() == false then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

--------------------------------------------------------------------------------

function item_bogduggs_baldric:IsMuted()	
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end
	if not self:GetCaster():IsHero() then
		return true
	end
	return self.BaseClass.IsMuted( self )
end

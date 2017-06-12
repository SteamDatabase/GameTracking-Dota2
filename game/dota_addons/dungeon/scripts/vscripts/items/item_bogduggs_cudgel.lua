item_bogduggs_cudgel = class({})
LinkLuaModifier( "modifier_item_bogduggs_cudgel", "modifiers/modifier_item_bogduggs_cudgel", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_bogduggs_cudgel:GetIntrinsicModifierName()
	return "modifier_item_bogduggs_cudgel"
end

--------------------------------------------------------------------------------

function item_bogduggs_cudgel:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

--------------------------------------------------------------------------------

function item_bogduggs_cudgel:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level and self:IsInBackpack() == false then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

--------------------------------------------------------------------------------

function item_bogduggs_cudgel:IsMuted()	
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end
	if not self:GetCaster():IsHero() then
		return true
	end
	return self.BaseClass.IsMuted( self )
end

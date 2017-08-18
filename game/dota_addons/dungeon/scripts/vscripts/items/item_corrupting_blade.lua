
item_corrupting_blade = class({})
LinkLuaModifier( "modifier_item_corrupting_blade", "modifiers/modifier_item_corrupting_blade", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_corrupting_blade_buff", "modifiers/modifier_item_corrupting_blade_buff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_corrupting_blade:GetIntrinsicModifierName()
	return "modifier_item_corrupting_blade"
end

--------------------------------------------------------------------------------

function item_corrupting_blade:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

--------------------------------------------------------------------------------

function item_corrupting_blade:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level and self:IsInBackpack() == false  then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

--------------------------------------------------------------------------------

function item_corrupting_blade:IsMuted()	
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end
	if not self:GetCaster():IsHero() then
		return true
	end
	return self.BaseClass.IsMuted( self )
end

--------------------------------------------------------------------------------


item_treads_of_ermacor = class({})
LinkLuaModifier( "modifier_item_treads_of_ermacor", "modifiers/modifier_item_treads_of_ermacor", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_treads_of_ermacor:GetIntrinsicModifierName()
	return "modifier_item_treads_of_ermacor"
end

--------------------------------------------------------------------------------

function item_treads_of_ermacor:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

--------------------------------------------------------------------------------

function item_treads_of_ermacor:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

--------------------------------------------------------------------------------

function item_treads_of_ermacor:IsMuted()	
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end
	if not self:GetCaster():IsHero() then
		return true
	end
	return self.BaseClass.IsMuted( self )
end

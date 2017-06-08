item_the_caustic_finale = class({})
LinkLuaModifier( "modifier_item_the_caustic_finale", "modifiers/modifier_item_the_caustic_finale", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_the_caustic_finale:GetIntrinsicModifierName()
	return "modifier_item_the_caustic_finale"
end

--------------------------------------------------------------------------------

function item_the_caustic_finale:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

--------------------------------------------------------------------------------

function item_the_caustic_finale:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

--------------------------------------------------------------------------------

function item_the_caustic_finale:IsMuted()	
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end
	if not self:GetCaster():IsHero() then
		return true
	end
	return self.BaseClass.IsMuted( self )
end

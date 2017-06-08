item_pelt_of_the_old_wolf = class({})
LinkLuaModifier( "modifier_item_pelt_of_the_old_wolf", "modifiers/modifier_item_pelt_of_the_old_wolf", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_pelt_of_the_old_wolf:GetIntrinsicModifierName()
	return "modifier_item_pelt_of_the_old_wolf"
end

--------------------------------------------------------------------------------

function item_pelt_of_the_old_wolf:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

--------------------------------------------------------------------------------

function item_pelt_of_the_old_wolf:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

--------------------------------------------------------------------------------

function item_pelt_of_the_old_wolf:IsMuted()	
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end
	if not self:GetCaster():IsHero() then
		return true
	end
	
	return self.BaseClass.IsMuted( self )
end

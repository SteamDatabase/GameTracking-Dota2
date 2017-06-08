item_rhyziks_eye = class({})
LinkLuaModifier( "modifier_item_rhyziks_eye", "modifiers/modifier_item_rhyziks_eye", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_rhyziks_eye:GetIntrinsicModifierName()
	return "modifier_item_rhyziks_eye"
end

--------------------------------------------------------------------------------

function item_rhyziks_eye:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

--------------------------------------------------------------------------------

function item_rhyziks_eye:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

--------------------------------------------------------------------------------

function item_rhyziks_eye:IsMuted()	
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end
	if not self:GetCaster():IsHero() then
		return true
	end
	return self.BaseClass.IsMuted( self )
end

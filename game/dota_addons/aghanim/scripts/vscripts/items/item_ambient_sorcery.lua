
item_ambient_sorcery = class({})
LinkLuaModifier( "modifier_item_ambient_sorcery", "modifiers/modifier_item_ambient_sorcery", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_ambient_sorcery_effect", "modifiers/modifier_item_ambient_sorcery_effect", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function item_ambient_sorcery:GetIntrinsicModifierName()
	return "modifier_item_ambient_sorcery"
end

--------------------------------------------------------------------------------

function item_ambient_sorcery:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

--------------------------------------------------------------------------------

function item_ambient_sorcery:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level and self:IsInBackpack() == false then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

--------------------------------------------------------------------------------

function item_ambient_sorcery:IsMuted()	
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end

	if not self:GetCaster():IsHero() then
		return true
	end

	return self.BaseClass.IsMuted( self )
end

--------------------------------------------------------------------------------

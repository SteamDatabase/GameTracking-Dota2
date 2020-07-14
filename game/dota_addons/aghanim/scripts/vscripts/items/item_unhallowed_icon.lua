item_unhallowed_icon = class({})
LinkLuaModifier( "modifier_item_unhallowed_icon", "modifiers/modifier_item_unhallowed_icon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_unhallowed_icon_effect", "modifiers/modifier_item_unhallowed_icon_effect", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function item_unhallowed_icon:GetIntrinsicModifierName()
	return "modifier_item_unhallowed_icon"
end

--------------------------------------------------------------------------------

function item_unhallowed_icon:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

--------------------------------------------------------------------------------

function item_unhallowed_icon:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level and self:IsInBackpack() == false then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

--------------------------------------------------------------------------------

function item_unhallowed_icon:IsMuted()	
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end
	if not self:GetCaster():IsHero() then
		return true
	end
	return self.BaseClass.IsMuted( self )
end

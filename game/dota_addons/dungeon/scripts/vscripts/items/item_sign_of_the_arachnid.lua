item_sign_of_the_arachnid = class({})
LinkLuaModifier( "modifier_item_sign_of_the_arachnid", "modifiers/modifier_item_sign_of_the_arachnid", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_sign_of_the_arachnid_effect", "modifiers/modifier_item_sign_of_the_arachnid_effect", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function item_sign_of_the_arachnid:GetIntrinsicModifierName()
	return "modifier_item_sign_of_the_arachnid"
end

--------------------------------------------------------------------------------

function item_sign_of_the_arachnid:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

--------------------------------------------------------------------------------

function item_sign_of_the_arachnid:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level and self:IsInBackpack() == false then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

--------------------------------------------------------------------------------

function item_sign_of_the_arachnid:IsMuted()	
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end
	if not self:GetCaster():IsHero() then
		return true
	end
	return self.BaseClass.IsMuted( self )
end

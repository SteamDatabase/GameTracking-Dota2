item_winter_embrace = class({})
LinkLuaModifier( "modifier_item_winter_embrace", "modifiers/modifier_item_winter_embrace", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_winter_embrace:GetIntrinsicModifierName()
	return "modifier_item_winter_embrace"
end

--------------------------------------------------------------------------------

function item_winter_embrace:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

--------------------------------------------------------------------------------

function item_winter_embrace:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level and self:IsInBackpack() == false then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

--------------------------------------------------------------------------------

function item_winter_embrace:IsMuted()	
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end
	if not self:GetCaster():IsHero() then
		return true
	end
	return self.BaseClass.IsMuted( self )
end

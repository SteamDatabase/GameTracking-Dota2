item_carapace_of_qaldin = class({})
LinkLuaModifier( "modifier_item_carapace_of_qaldin", "modifiers/modifier_item_carapace_of_qaldin", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_carapace_of_qaldin:GetIntrinsicModifierName()
	return "modifier_item_carapace_of_qaldin"
end

--------------------------------------------------------------------------------

function item_carapace_of_qaldin:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

--------------------------------------------------------------------------------

function item_carapace_of_qaldin:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level and self:IsInBackpack() == false then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

--------------------------------------------------------------------------------

function item_carapace_of_qaldin:IsMuted()	
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end
	if not self:GetCaster():IsHero() then
		return true
	end
	return self.BaseClass.IsMuted( self )
end

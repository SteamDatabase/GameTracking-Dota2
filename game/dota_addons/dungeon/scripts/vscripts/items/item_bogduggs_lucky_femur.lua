item_bogduggs_lucky_femur = class({})
LinkLuaModifier( "modifier_item_bogduggs_lucky_femur", "modifiers/modifier_item_bogduggs_lucky_femur", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_bogduggs_lucky_femur:GetIntrinsicModifierName()
	return "modifier_item_bogduggs_lucky_femur"
end

--------------------------------------------------------------------------------

function item_bogduggs_lucky_femur:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

--------------------------------------------------------------------------------

function item_bogduggs_lucky_femur:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

--------------------------------------------------------------------------------

function item_bogduggs_lucky_femur:IsMuted()	
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end
	if not self:GetCaster():IsHero() then
		return true
	end
	return self.BaseClass.IsMuted( self )
end

item_guardian_shell = class({})
LinkLuaModifier( "modifier_item_guardian_shell", "modifiers/modifier_item_guardian_shell", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_guardian_shell:GetIntrinsicModifierName()
	return "modifier_item_guardian_shell"
end

--------------------------------------------------------------------------------

function item_guardian_shell:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

--------------------------------------------------------------------------------

function item_guardian_shell:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level and self:IsInBackpack() == false then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

--------------------------------------------------------------------------------

function item_guardian_shell:IsMuted()	
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end
	if not self:GetCaster():IsHero() then
		return true
	end
	return self.BaseClass.IsMuted( self )
end

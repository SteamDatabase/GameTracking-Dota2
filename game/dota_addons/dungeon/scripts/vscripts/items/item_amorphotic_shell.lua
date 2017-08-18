item_amorphotic_shell = class({})
LinkLuaModifier( "modifier_item_amorphotic_shell", "modifiers/modifier_item_amorphotic_shell", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_amorphotic_shell_effect", "modifiers/modifier_item_amorphotic_shell_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_amorphotic_shell:GetIntrinsicModifierName()
	return "modifier_item_amorphotic_shell"
end

--------------------------------------------------------------------------------

function item_amorphotic_shell:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

--------------------------------------------------------------------------------

function item_amorphotic_shell:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level and self:IsInBackpack() == false then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

--------------------------------------------------------------------------------

function item_amorphotic_shell:IsMuted()	
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end

	if not self:GetCaster():IsHero() then
		return true
	end

	return self.BaseClass.IsMuted( self )
end

--------------------------------------------------------------------------------

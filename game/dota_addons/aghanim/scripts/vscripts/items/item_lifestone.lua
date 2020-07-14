
item_lifestone = class({})
LinkLuaModifier( "modifier_item_lifestone", "modifiers/modifier_item_lifestone", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_lifestone_pact", "modifiers/modifier_item_lifestone_pact", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_lifestone:GetIntrinsicModifierName()
	return "modifier_item_lifestone"
end

--------------------------------------------------------------------------------

function item_lifestone:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		if hCaster:HasModifier( "modifier_item_lifestone_pact" ) then
			hCaster:RemoveModifierByName( "modifier_item_lifestone_pact" )
		else
			hCaster:AddNewModifier( hCaster, self, "modifier_item_lifestone_pact", { duration = -1 } )
		end
	end
end

--------------------------------------------------------------------------------

function item_lifestone:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

--------------------------------------------------------------------------------

function item_lifestone:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level and self:IsInBackpack() == false then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

--------------------------------------------------------------------------------

function item_lifestone:IsMuted()
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end
	if not self:GetCaster():IsHero() then
		return true
	end
	
	return self.BaseClass.IsMuted( self )
end

--------------------------------------------------------------------------------



item_glimmerdark_shield = class({})
LinkLuaModifier( "modifier_item_glimmerdark_shield", "modifiers/modifier_item_glimmerdark_shield", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_glimmerdark_shield_prism", "modifiers/modifier_item_glimmerdark_shield_prism", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_glimmerdark_shield:OnSpellStart()
	self.prism_duration = self:GetSpecialValueFor( "prism_duration" )

	if IsServer() then
		local hCaster = self:GetCaster()
		hCaster:AddNewModifier( hCaster, self, "modifier_item_glimmerdark_shield_prism", { duration = self.prism_duration } )

		EmitSoundOn( "DOTA_Item.GhostScepter.Activate", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function item_glimmerdark_shield:GetIntrinsicModifierName()
	return "modifier_item_glimmerdark_shield"
end

--------------------------------------------------------------------------------

function item_glimmerdark_shield:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

--------------------------------------------------------------------------------

function item_glimmerdark_shield:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level and self:IsInBackpack() == false then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

--------------------------------------------------------------------------------

function item_glimmerdark_shield:IsMuted()
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end
	if not self:GetCaster():IsHero() then
		return true
	end
	
	return self.BaseClass.IsMuted( self )
end

--------------------------------------------------------------------------------


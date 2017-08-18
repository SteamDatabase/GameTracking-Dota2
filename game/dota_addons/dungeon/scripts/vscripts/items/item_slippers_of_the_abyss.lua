
item_slippers_of_the_abyss = class({})
LinkLuaModifier( "modifier_item_slippers_of_the_abyss", "modifiers/modifier_item_slippers_of_the_abyss", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_slippers_of_the_abyss_sprint", "modifiers/modifier_item_slippers_of_the_abyss_sprint", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_slippers_of_the_abyss:GetIntrinsicModifierName()
	return "modifier_item_slippers_of_the_abyss"
end

--------------------------------------------------------------------------------

function item_slippers_of_the_abyss:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

--------------------------------------------------------------------------------

function item_slippers_of_the_abyss:OnSpellStart()
	if IsServer() then
		self.sprint_duration = self:GetSpecialValueFor( "sprint_duration" )

		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_item_slippers_of_the_abyss_sprint", { duration = self.sprint_duration } )

		EmitSoundOn( "Siltbreaker.Sprint", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function item_slippers_of_the_abyss:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level and self:IsInBackpack() == false then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

--------------------------------------------------------------------------------

function item_slippers_of_the_abyss:IsMuted()	
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end
	if not self:GetCaster():IsHero() then
		return true
	end
	return self.BaseClass.IsMuted( self )
end

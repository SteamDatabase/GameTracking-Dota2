modifier_sven_warcry_lua = class({})
--------------------------------------------------------------------------------

function modifier_sven_warcry_lua:OnCreated( kv )
	self.warcry_armor = self:GetAbility():GetSpecialValueFor( "warcry_armor" )
	self.warcry_movespeed = self:GetAbility():GetSpecialValueFor( "warcry_movespeed" )
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_warcry_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end

--------------------------------------------------------------------------------

function modifier_sven_warcry_lua:OnRefresh( kv )
	self.warcry_armor = self:GetAbility():GetSpecialValueFor( "warcry_armor" )
	self.warcry_movespeed = self:GetAbility():GetSpecialValueFor( "warcry_movespeed" )
end

--------------------------------------------------------------------------------

function modifier_sven_warcry_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_sven_warcry_lua:GetActivityTranslationModifiers( params )
	if self:GetParent() == self:GetCaster() then
		return "sven_warcry"
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_sven_warcry_lua:GetModifierMoveSpeedBonus_Percentage( params )
	return self.warcry_movespeed
end

--------------------------------------------------------------------------------

function modifier_sven_warcry_lua:GetModifierPhysicalArmorBonus( params )
	return self.warcry_armor
end

--------------------------------------------------------------------------------
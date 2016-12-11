modifier_vengefulspirit_wave_of_terror_lua = class({})

--------------------------------------------------------------------------------

function modifier_vengefulspirit_wave_of_terror_lua:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_vengefulspirit_wave_of_terror_lua:GetEffectName()
	return "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror_recipient.vpcf"
end

--------------------------------------------------------------------------------

function modifier_vengefulspirit_wave_of_terror_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_vengefulspirit_wave_of_terror_lua:OnCreated( kv )
	self.armor_reduction = self:GetAbility():GetSpecialValueFor( "armor_reduction" )
end

--------------------------------------------------------------------------------

function modifier_vengefulspirit_wave_of_terror_lua:OnRefresh( kv )
	self.armor_reduction = self:GetAbility():GetSpecialValueFor( "armor_reduction" )
end

--------------------------------------------------------------------------------

function modifier_vengefulspirit_wave_of_terror_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_vengefulspirit_wave_of_terror_lua:GetModifierPhysicalArmorBonus( params )
	return self.armor_reduction
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

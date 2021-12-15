
frostbitten_shaman_frost_armor = class({})
LinkLuaModifier( "modifier_frostbitten_shaman_frost_armor", "modifiers/creatures/modifier_frostbitten_shaman_frost_armor", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_frostbitten_shaman_frost_armor_debuff", "modifiers/creatures/modifier_frostbitten_shaman_frost_armor_debuff", LUA_MODIFIER_MOTION_NONE )


----------------------------------------------------------------------------------------

function frostbitten_shaman_frost_armor:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lich/lich_slowed_cold.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lich/lich_frost_armor.vpcf", context )
end

-----------------------------------------------------------------------------

function frostbitten_shaman_frost_armor:OnSpellStart()
	if IsServer() then
		local hTarget = self:GetCursorTarget()
		if hTarget then
			local buff_duration = self:GetSpecialValueFor( "buff_duration" )
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_frostbitten_shaman_frost_armor", { duration = buff_duration } )
		end
	end
end

-----------------------------------------------------------------------------


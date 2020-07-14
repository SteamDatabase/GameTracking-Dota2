ascension_vampiric = class( {} )

LinkLuaModifier( "modifier_ascension_vampiric", "modifiers/modifier_ascension_vampiric", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function ascension_vampiric:Precache( context )
	PrecacheResource( "particle", "particles/items2_fx/satanic_buff.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_life_stealer_rage.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_life_stealer/life_stealer_rage.vpcf", context )
	PrecacheResource( "particle", "particles/items3_fx/octarine_core_lifesteal.vpcf", context )
	PrecacheResource( "particle", "particles/generic_gameplay/generic_lifesteal.vpcf", context )
end

--------------------------------------------------------------------------------

function ascension_vampiric:OnSpellStart()

	if not IsServer() then
		return
	end

	EmitSoundOn( "DOTA_Item.Satanic.Activate", self:GetCaster() )

	local flDuration = self:GetSpecialValueFor( "duration" )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_ascension_vampiric", { duration = flDuration } )
end


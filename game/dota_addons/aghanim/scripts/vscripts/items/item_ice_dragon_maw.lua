item_ice_dragon_maw = class({})
LinkLuaModifier( "modifier_item_ice_dragon_maw", "modifiers/modifier_item_ice_dragon_maw", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_large_frostbitten_icicle", "modifiers/modifier_large_frostbitten_icicle", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_ice_dragon_maw:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_crystalmaiden/maiden_frostbite.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_wyvern_cold_embrace.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf", context )
end

--------------------------------------------------------------------------------

function item_ice_dragon_maw:GetIntrinsicModifierName()
	return "modifier_item_ice_dragon_maw"
end

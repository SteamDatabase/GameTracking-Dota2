
sled_penguin_passive = class({})

LinkLuaModifier( "modifier_sled_penguin_passive", "modifiers/modifier_sled_penguin_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sled_penguin_movement", "modifiers/modifier_sled_penguin_movement", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_sled_penguin_crash", "modifiers/modifier_sled_penguin_crash", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_sled_penguin_impairment", "modifiers/modifier_sled_penguin_impairment", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function sled_penguin_passive:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_drunken_haze_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_brewmaster_drunken_haze.vpcf", context )
end
 
--------------------------------------------------------------------------------

function sled_penguin_passive:GetIntrinsicModifierName()
	return "modifier_sled_penguin_passive"
end

--------------------------------------------------------------------------------

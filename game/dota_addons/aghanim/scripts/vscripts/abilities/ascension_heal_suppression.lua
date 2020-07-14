
ascension_heal_suppression = class({})
LinkLuaModifier( "modifier_ascension_heal_suppression", "modifiers/modifier_ascension_heal_suppression", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ascension_heal_suppression_aura", "modifiers/modifier_ascension_heal_suppression_aura", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function ascension_heal_suppression:Precache( context )
	PrecacheResource( "particle", "particles/items4_fx/spirit_vessel_damage.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_necrolyte_spirit.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_necrolyte/necrolyte_spirit.vpcf", context )
end

--------------------------------------------------------------------------------

function ascension_heal_suppression:GetIntrinsicModifierName()
	return "modifier_ascension_heal_suppression_aura"
end

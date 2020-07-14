ascension_chilling_touch = class( {} )

LinkLuaModifier( "modifier_ascension_chilling_touch", "modifiers/modifier_ascension_chilling_touch", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function ascension_chilling_touch:Precache( context )
	PrecacheResource( "particle", "particles/generic_gameplay/generic_slowed_cold.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_frost.vpcf", context )
end

--------------------------------------------------------------------------------

function ascension_chilling_touch:GetIntrinsicModifierName()
	return "modifier_ascension_chilling_touch"
end

--------------------------------------------------------------------------------

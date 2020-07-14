ascension_extra_fast = class( {} )

LinkLuaModifier( "modifier_ascension_extra_fast", "modifiers/modifier_ascension_extra_fast", LUA_MODIFIER_MOTION_NONE )


function ascension_extra_fast:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf", context )
end

--------------------------------------------------------------------------------

function ascension_extra_fast:GetIntrinsicModifierName()
	return "modifier_ascension_extra_fast"
end

--------------------------------------------------------------------------------



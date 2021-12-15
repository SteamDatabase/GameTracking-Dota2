
polarity_ghost_captain_passive = class({})

LinkLuaModifier( "modifier_polarity_ghost_captain_passive", "modifiers/creatures/modifier_polarity_ghost_captain_passive", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function polarity_ghost_captain_passive:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_death_prophet/death_prophet_death.vpcf", context )
	PrecacheResource( "particle", "particles/polarity/polarity_status_positive.vpcf", context )
	PrecacheResource( "particle", "particles/polarity/polarity_status_negative.vpcf", context )
end

--------------------------------------------------------------------------------

function polarity_ghost_captain_passive:GetIntrinsicModifierName()
	return "modifier_polarity_ghost_captain_passive"
end

--------------------------------------------------------------------------------


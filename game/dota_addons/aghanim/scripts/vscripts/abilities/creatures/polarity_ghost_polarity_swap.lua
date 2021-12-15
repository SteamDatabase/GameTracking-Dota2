
polarity_ghost_polarity_swap = class({})

LinkLuaModifier( "modifier_polarity_ghost_polarity_swap", "modifiers/creatures/modifier_polarity_ghost_polarity_swap", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function polarity_ghost_polarity_swap:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_meld_attack.vpcf", context )
end

--------------------------------------------------------------------------------

function polarity_ghost_polarity_swap:GetIntrinsicModifierName()
	return "modifier_polarity_ghost_polarity_swap"
end

--------------------------------------------------------------------------------
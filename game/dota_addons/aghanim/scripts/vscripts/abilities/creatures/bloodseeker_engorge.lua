
bloodseeker_engorge = class({})

LinkLuaModifier( "modifier_bloodseeker_engorge", "modifiers/creatures/modifier_bloodseeker_engorge", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function bloodseeker_engorge:Precache( context )
	--PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context )
end

--------------------------------------------------------------------------------

function bloodseeker_engorge:GetIntrinsicModifierName()
	return "modifier_bloodseeker_engorge"
end

-----------------------------------------------------------------------------------------

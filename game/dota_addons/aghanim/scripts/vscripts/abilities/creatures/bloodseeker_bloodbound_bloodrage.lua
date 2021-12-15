
bloodseeker_bloodbound_bloodrage = class({})
LinkLuaModifier( "modifier_bloodseeker_bloodbound_bloodrage", "modifiers/creatures/modifier_bloodseeker_bloodbound_bloodrage", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function bloodseeker_bloodbound_bloodrage:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf", context )
end

-----------------------------------------------------------------------------------------


function bloodseeker_bloodbound_bloodrage:GetIntrinsicModifierName()
	return "modifier_bloodseeker_bloodbound_bloodrage"
end

-----------------------------------------------------------------------------------------

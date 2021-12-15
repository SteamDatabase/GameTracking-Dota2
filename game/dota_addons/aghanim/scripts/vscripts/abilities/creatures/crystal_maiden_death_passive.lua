
crystal_maiden_death_passive = class({})

LinkLuaModifier( "modifier_crystal_maiden_death_passive", "modifiers/creatures/modifier_crystal_maiden_death_passive", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function crystal_maiden_death_passive:Precache( context )
	PrecacheResource( "particle", "particles/creatures/crystal_maiden/maiden_death_creature.vpcf", context )
end

--------------------------------------------------------------------------------

function crystal_maiden_death_passive:GetIntrinsicModifierName()
	return "modifier_crystal_maiden_death_passive"
end

--------------------------------------------------------------------------------


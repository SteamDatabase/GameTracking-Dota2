
earth_spirit_statue_passive = class({})
LinkLuaModifier( "modifier_earth_spirit_statue_passive", "modifiers/creatures/modifier_earth_spirit_statue_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_earth_spirit_statue_stoneform", "modifiers/creatures/modifier_earth_spirit_statue_stoneform", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function earth_spirit_statue_passive:Precache( context )
	PrecacheModel( "models/heroes/attachto_ghost/attachto_ghost.vmdl", context )
end

-----------------------------------------------------------------------------------------

function earth_spirit_statue_passive:GetIntrinsicModifierName()
	return "modifier_earth_spirit_statue_passive"
end

-----------------------------------------------------------------------------------------

hulk_rot = class({})
LinkLuaModifier( "modifier_hulk_rot", "modifiers/creatures/modifier_hulk_rot", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function hulk_rot:Precache( context )
	--PrecacheResource( "particle", "particles/econ/items/pudge/pudge_immortal_arm/pudge_immortal_arm_rot.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/hulk/hulk_radiant_pudge_black_death_rot.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/hulk/hulk_dire_pudge_black_death_rot.vpcf", context )
	--PrecacheResource( "particle", "particles/units/heroes/hero_pudge/pudge_rot.vpcf", context )
end

--------------------------------------------------------------------------------

function hulk_rot:GetIntrinsicModifierName()
	return "modifier_hulk_rot"
end

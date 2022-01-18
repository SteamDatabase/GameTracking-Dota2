item_bogduggs_cudgel = class({})
LinkLuaModifier( "modifier_item_bogduggs_cudgel", "modifiers/modifier_item_bogduggs_cudgel", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function item_bogduggs_cudgel:Precache( context )

	PrecacheResource( "particle", "particles/creatures/ogre/ogre_melee_smash.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context )

end

--------------------------------------------------------------------------------

function item_bogduggs_cudgel:GetIntrinsicModifierName()
	return "modifier_item_bogduggs_cudgel"
end

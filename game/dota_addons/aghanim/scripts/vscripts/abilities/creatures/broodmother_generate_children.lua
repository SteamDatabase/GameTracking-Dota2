
-- Note: this ability gets added by hand to the dummy unit that Broodmother creates.

broodmother_generate_children = class({})
LinkLuaModifier( "modifier_broodmother_generate_children", "modifiers/creatures/modifier_broodmother_generate_children", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function broodmother_generate_children:Precache( context )

	PrecacheResource( "particle", "particles/baby_brood_venom_pool.vpcf", context )
	PrecacheUnitByNameSync( "npc_dota_creature_broodmother_baby_c", context, -1 )

end

--------------------------------------------------------------------------------

function broodmother_generate_children:GetIntrinsicModifierName()
	return "modifier_broodmother_generate_children"
end

--------------------------------------------------------------------------------

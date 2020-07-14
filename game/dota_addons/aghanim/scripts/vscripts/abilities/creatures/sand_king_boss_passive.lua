
sand_king_boss_passive = class({})
LinkLuaModifier( "modifier_sand_king_boss_passive", "modifiers/creatures/modifier_sand_king_boss_passive", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------

function sand_king_boss_passive:Precache( context )

	PrecacheResource( "particle", "particles/units/heroes/hero_sandking/sandking_caustic_finale_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", context )

end

-----------------------------------------------------------------------------------------

function sand_king_boss_passive:GetIntrinsicModifierName()
	return "modifier_sand_king_boss_passive"
end

-----------------------------------------------------------------------------------------

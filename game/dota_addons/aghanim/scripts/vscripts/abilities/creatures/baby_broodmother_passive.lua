
baby_broodmother_passive = class({})

LinkLuaModifier( "modifier_baby_broodmother_passive", "modifiers/creatures/modifier_baby_broodmother_passive", LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier( "modifier_baby_broodmother_venom_pool", "modifiers/creatures/modifier_baby_broodmother_venom_pool", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function baby_broodmother_passive:Precache( context )

	PrecacheResource( "particle", "particles/baby_brood_venom_pool.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_viper/viper_nethertoxin_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/generic_gameplay/generic_silenced_lanecreeps.vpcf", context )
	PrecacheResource( "particle", "particles/generic_gameplay/generic_silenced.vpcf", context )
	PrecacheResource( "particle", "particles/generic_gameplay/generic_break.vpcf", context )

end

--------------------------------------------------------------------------------

function baby_broodmother_passive:GetIntrinsicModifierName()
	return "modifier_baby_broodmother_passive"
end

--------------------------------------------------------------------------------



amoeba_baby_death_passive = class({})

LinkLuaModifier( "modifier_amoeba_baby_death_passive", "modifiers/creatures/modifier_amoeba_baby_death_passive", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function amoeba_baby_death_passive:Precache( context )
	PrecacheResource( "particle", "particles/act_2/amoeba_baby_death.vpcf", context )
end

--------------------------------------------------------------------------------

function amoeba_baby_death_passive:GetIntrinsicModifierName()
	return "modifier_amoeba_baby_death_passive"
end

--------------------------------------------------------------------------------


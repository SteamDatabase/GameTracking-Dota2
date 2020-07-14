aghanim_passive = class( {} )

LinkLuaModifier( "modifier_aghanim_passive", "modifiers/creatures/modifier_aghanim_passive", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function aghanim_passive:Precache( context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_outro_linger.vpcf", context )
end

--------------------------------------------------------------------------------

function aghanim_passive:GetIntrinsicModifierName()
	return "modifier_aghanim_passive"
end

--------------------------------------------------------------------------------

diretide_roshan_passive = class({})

----------------------------------------------------------------------------------------

LinkLuaModifier( "modifier_diretide_roshan_passive", "modifiers/creatures/modifier_diretide_roshan_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_diretide_roshan_curse_debuff", "modifiers/gameplay/modifier_diretide_roshan_curse_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_roshan_angry", "modifiers/creatures/modifier_roshan_angry", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function diretide_roshan_passive:Precache( context )
	PrecacheResource( "particle", "particles/hw_fx/candy_fed.vpcf", context )
	PrecacheResource( "particle", "particles/hw_fx/status_effect_fed.vpcf", context )
	PrecacheResource( "particle", "particles/roshan/roshan_curse/roshan_curse_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/roshan/roshan_curse/roshan_curse_thundergods_wrath.vpcf", context )
	PrecacheResource( "particle", "particles/roshan/curse_dot/roshan_curse_bleed.vpcf", context )
	PrecacheResource( "particle", "particles/roshan/roshan_angry/roshan_angry_ambient.vpcf", context )
end

----------------------------------------------------------------------------------------

function diretide_roshan_passive:GetIntrinsicModifierName()
	return "modifier_diretide_roshan_passive"
end

--------------------------------------------------------------------------------

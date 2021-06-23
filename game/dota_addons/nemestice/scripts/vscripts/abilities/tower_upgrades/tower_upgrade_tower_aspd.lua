
tower_upgrade_tower_aspd = class({})

--------------------------------------------------------------------------------

LinkLuaModifier( "modifier_tower_upgrade_tower_aspd", "modifiers/tower_upgrades/modifier_tower_upgrade_tower_aspd", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function tower_upgrade_tower_aspd:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_alacrity_buff.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_alacrity.vpcf", context )
end

--------------------------------------------------------------------------------

function tower_upgrade_tower_aspd:GetIntrinsicModifierName()
	return "modifier_tower_upgrade_tower_aspd"
end

--------------------------------------------------------------------------------

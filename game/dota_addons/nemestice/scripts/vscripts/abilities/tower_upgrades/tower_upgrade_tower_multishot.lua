
tower_upgrade_tower_multishot = class({})

--------------------------------------------------------------------------------

LinkLuaModifier( "modifier_tower_upgrade_tower_multishot", "modifiers/tower_upgrades/modifier_tower_upgrade_tower_multishot", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function tower_upgrade_tower_multishot:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_gyrocopter/gyro_flak_cannon_overhead.vpcf", context )
end

--------------------------------------------------------------------------------

function tower_upgrade_tower_multishot:GetIntrinsicModifierName()
	return "modifier_tower_upgrade_tower_multishot"
end

--------------------------------------------------------------------------------

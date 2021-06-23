
tower_upgrade_spawn_hellbears = class({})

--------------------------------------------------------------------------------

LinkLuaModifier( "modifier_tower_upgrade_spawn_hellbears", "modifiers/tower_upgrades/modifier_tower_upgrade_spawn_hellbears", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function tower_upgrade_spawn_hellbears:Precache( context )
	--PrecacheResource( "particle", "particles/hw_fx/candy_fed.vpcf", context )
end

--------------------------------------------------------------------------------

function tower_upgrade_spawn_hellbears:GetIntrinsicModifierName()
	return "modifier_tower_upgrade_spawn_hellbears"
end

--------------------------------------------------------------------------------

function tower_upgrade_spawn_hellbears:GetUpgradeBuildingName()
	return "npc_dota_building_tower_upgrade_hellbear"
end

--------------------------------------------------------------------------------


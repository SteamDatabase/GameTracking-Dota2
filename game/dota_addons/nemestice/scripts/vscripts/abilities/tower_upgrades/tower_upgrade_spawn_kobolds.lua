
tower_upgrade_spawn_kobolds = class({})

--------------------------------------------------------------------------------

LinkLuaModifier( "modifier_tower_upgrade_spawn_kobolds", "modifiers/tower_upgrades/modifier_tower_upgrade_spawn_kobolds", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function tower_upgrade_spawn_kobolds:Precache( context )
	--PrecacheResource( "particle", "particles/hw_fx/candy_fed.vpcf", context )
end

--------------------------------------------------------------------------------

function tower_upgrade_spawn_kobolds:GetIntrinsicModifierName()
	return "modifier_tower_upgrade_spawn_kobolds"
end

--------------------------------------------------------------------------------

function tower_upgrade_spawn_kobolds:GetUpgradeBuildingName()
	return "npc_dota_building_tower_upgrade_kobold"
end

	
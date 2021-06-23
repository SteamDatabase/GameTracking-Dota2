
tower_upgrade_spawn_troll_priests = class({})

--------------------------------------------------------------------------------

LinkLuaModifier( "modifier_tower_upgrade_spawn_troll_priests", "modifiers/tower_upgrades/modifier_tower_upgrade_spawn_troll_priests", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function tower_upgrade_spawn_troll_priests:Precache( context )
	--PrecacheResource( "particle", "particles/hw_fx/candy_fed.vpcf", context )
end

--------------------------------------------------------------------------------

function tower_upgrade_spawn_troll_priests:GetIntrinsicModifierName()
	return "modifier_tower_upgrade_spawn_troll_priests"
end

--------------------------------------------------------------------------------

function tower_upgrade_spawn_troll_priests:GetUpgradeBuildingName()
	return "npc_dota_building_tower_upgrade_troll_priest"
end

	




tower_upgrade_spawn_lane_creeps = class({})

--------------------------------------------------------------------------------

LinkLuaModifier( "modifier_tower_upgrade_spawn_lane_creeps", "modifiers/tower_upgrades/modifier_tower_upgrade_spawn_lane_creeps", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function tower_upgrade_spawn_lane_creeps:Precache( context )
	--PrecacheResource( "particle", "particles/hw_fx/candy_fed.vpcf", context )
end

--------------------------------------------------------------------------------

function tower_upgrade_spawn_lane_creeps:GetIntrinsicModifierName()
	return "modifier_tower_upgrade_spawn_lane_creeps"
end

--------------------------------------------------------------------------------

function tower_upgrade_spawn_lane_creeps:GetUpgradeBuildingName()
	return nil
end

	



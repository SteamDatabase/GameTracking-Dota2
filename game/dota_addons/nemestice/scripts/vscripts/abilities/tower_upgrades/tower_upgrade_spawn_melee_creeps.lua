
tower_upgrade_spawn_melee_creeps = class({})

--------------------------------------------------------------------------------

LinkLuaModifier( "modifier_tower_upgrade_spawn_melee_creeps", "modifiers/tower_upgrades/modifier_tower_upgrade_spawn_melee_creeps", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function tower_upgrade_spawn_melee_creeps:Precache( context )
	--PrecacheResource( "particle", "particles/hw_fx/candy_fed.vpcf", context )
end

--------------------------------------------------------------------------------

function tower_upgrade_spawn_melee_creeps:GetIntrinsicModifierName()
	return "modifier_tower_upgrade_spawn_melee_creeps"
end



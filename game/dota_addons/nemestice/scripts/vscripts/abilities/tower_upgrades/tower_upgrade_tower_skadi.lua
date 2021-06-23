
tower_upgrade_tower_skadi = class({})

--------------------------------------------------------------------------------

LinkLuaModifier( "modifier_tower_upgrade_tower_skadi", "modifiers/tower_upgrades/modifier_tower_upgrade_tower_skadi", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function tower_upgrade_tower_skadi:Precache( context )
end

--------------------------------------------------------------------------------

function tower_upgrade_tower_skadi:GetIntrinsicModifierName()
	return "modifier_tower_upgrade_tower_skadi"
end

--------------------------------------------------------------------------------

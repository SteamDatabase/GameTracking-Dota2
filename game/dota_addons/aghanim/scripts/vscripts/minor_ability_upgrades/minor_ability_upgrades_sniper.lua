local Sniper =
{
	{
		description = "aghsfort_sniper_shrapnel_percent_cooldown",
		ability_name = "aghsfort_sniper_shrapnel",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
	
	{
		description = "aghsfort_sniper_shrapnel_flat_damage",
		ability_name = "aghsfort_sniper_shrapnel",
		special_value_name = "shrapnel_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
	},

	{
		description = "aghsfort_sniper_shrapnel_flat_radius",
		ability_name = "aghsfort_sniper_shrapnel",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 75,
	},

	{
		description = "aghsfort_sniper_shrapnel_flat_slow_movement_speed",
		ability_name = "aghsfort_sniper_shrapnel",
		special_value_name = "slow_movement_speed",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = -12,
	},

	{
		description = "aghsfort_sniper_shrapnel_percent_mana_cost",
		ability_name = "aghsfort_sniper_shrapnel",
		special_value_name = "mana_cost",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
	{
		description = "aghsfort_sniper_shrapnel_duration",
		ability_name = "aghsfort_sniper_shrapnel",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 2,
	},
	{
		description = "aghsfort_sniper_headshot_flat_damage",
		ability_name = "aghsfort_sniper_headshot",
		special_value_name = "damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 35,
	},

	{
		description = "aghsfort_sniper_headshot_knockback_distance",
		ability_name = "aghsfort_sniper_headshot",
		special_value_name = "knockback_distance",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
	},

	{
		description = "aghsfort_sniper_headshot_proc_chance",
		ability_name = "aghsfort_sniper_headshot",
		special_value_name = "proc_chance",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 7,
	},

	{
		description = "aghsfort_sniper_headshot_debuff_duration",
		ability_name = "aghsfort_sniper_headshot",
		special_value_name = "slow_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.5,
	},

	-- {
	-- 	description = "aghsfort_sniper_take_aim_percent_cooldown",
	-- 	ability_name = "aghsfort_sniper_take_aim",
	-- 	special_value_name = "cooldown",
	-- 	operator = MINOR_ABILITY_UPGRADE_OP_MUL,
	-- 	value = 12,
	-- },

	{
		description = "aghsfort_sniper_take_aim_flat_bonus_attack_range",
		ability_name = "aghsfort_sniper_take_aim",
		special_value_name = "bonus_attack_range",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 75,
	},

	{
		description = "aghsfort_sniper_assassinate_flat_damage",
		ability_name = "aghsfort_sniper_assassinate",
		special_value_name = "damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 165,
	},

	{
		description = "aghsfort_sniper_assassinate_percent_mana_cost",
		ability_name = "aghsfort_sniper_assassinate",
		special_value_name = "mana_cost",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 15,
	},

	{
		description = "aghsfort_sniper_assassinate_percent_cooldown",
		ability_name = "aghsfort_sniper_assassinate",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},

	{
		description = "aghsfort_sniper_assassinate_projectile_speed",
		ability_name = "aghsfort_sniper_assassinate",
		special_value_name = "projectile_speed",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1250,
	},

}

return Sniper

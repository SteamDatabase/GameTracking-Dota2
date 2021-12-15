
local Phoenix =
{
	--------------------------------------------------------------------------------
	-- Icarus Dive
	--------------------------------------------------------------------------------
	{
		description = "aghsfort_phoenix_icarus_dive_mana_cost_cooldown",
		ability_name = "aghsfort_phoenix_icarus_dive",
		special_values =
		{
			{
				special_value_name = "mana_cost",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
			{
				special_value_name = "cooldown",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
		},
	},

	{
		description = "aghsfort_phoenix_icarus_dive_burn_duration",
		ability_name = "aghsfort_phoenix_icarus_dive",
		special_value_name = "burn_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.0,
	},

	{
		description = "aghsfort_phoenix_icarus_dive_damage_per_second",
		ability_name = "aghsfort_phoenix_icarus_dive",
		special_value_name = "damage_per_second",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 20,
	},

	{
		description = "aghsfort_phoenix_icarus_dive_move_slow",
		ability_name = "aghsfort_phoenix_icarus_dive",
		special_value_name = "slow_movement_speed_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
	},

	--------------------------------------------------------------------------------
	-- Fire Spirits
	--------------------------------------------------------------------------------
	{
		description = "aghsfort_phoenix_fire_spirits_mana_cost_cooldown",
		ability_name = "aghsfort_phoenix_fire_spirits",
		special_values =
		{
			{
				special_value_name = "mana_cost",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
			{
				special_value_name = "cooldown",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
		},
	},

	{
		description = "aghsfort_phoenix_fire_spirits_spirit_count",
		ability_name = "aghsfort_phoenix_fire_spirits",
		special_value_name = "spirit_count",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},

	{
		description = "aghsfort_phoenix_fire_spirits_radius",
		ability_name = "aghsfort_phoenix_fire_spirits",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 40,
	},

	{
		description = "aghsfort_phoenix_fire_spirits_burn_duration",
		ability_name = "aghsfort_phoenix_fire_spirits",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.0,
	},

	{
		description = "aghsfort_phoenix_fire_spirits_attackspeed_slow",
		ability_name = "aghsfort_phoenix_fire_spirits",
		special_value_name = "attackspeed_slow",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 15,
	},

	{
		description = "aghsfort_phoenix_fire_spirits_damage_per_second",
		ability_name = "aghsfort_phoenix_fire_spirits",
		special_value_name = "damage_per_second",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 15,
	},

	--------------------------------------------------------------------------------
	-- Sun Ray
	--------------------------------------------------------------------------------
	{
		description = "aghsfort_phoenix_sun_ray_mana_cost_cooldown",
		ability_name = "aghsfort_phoenix_sun_ray",
		special_values =
		{
			{
				special_value_name = "mana_cost",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
			{
				special_value_name = "cooldown",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
		},
	},

	{
		description = "aghsfort_phoenix_sun_ray_base_damage",
		ability_name = "aghsfort_phoenix_sun_ray",
		special_value_name = "base_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 15,
	},

	{
		description = "aghsfort_phoenix_sun_ray_hp_perc_heal",
		ability_name = "aghsfort_phoenix_sun_ray",
		special_value_name = "hp_perc_heal",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.5,
	},

	--------------------------------------------------------------------------------
	-- Supernova
	--------------------------------------------------------------------------------
	{
		description = "aghsfort_phoenix_supernova_mana_cost_cooldown",
		ability_name = "aghsfort_phoenix_supernova",
		special_values =
		{
			{
				special_value_name = "mana_cost",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
			{
				special_value_name = "cooldown",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
		},
	},

	{
		description = "aghsfort_phoenix_supernova_damage_per_sec",
		ability_name = "aghsfort_phoenix_supernova",
		special_value_name = "damage_per_sec",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 30,
	},

	{
		description = "aghsfort_phoenix_supernova_stun_duration",
		ability_name = "aghsfort_phoenix_supernova",
		special_value_name = "stun_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.5,
	},

	{
		description = "aghsfort_phoenix_supernova_attacks_to_kill",
		ability_name = "aghsfort_phoenix_supernova",
		special_value_name = "attacks_to_kill",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 6,
	},

	{
		description = "aghsfort_phoenix_supernova_aura_radius",
		ability_name = "aghsfort_phoenix_supernova",
		special_value_name = "aura_radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 200,
	},

}

return Phoenix

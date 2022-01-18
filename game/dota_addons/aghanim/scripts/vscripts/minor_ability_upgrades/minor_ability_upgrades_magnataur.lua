local Magnus =
{
	{
		description = "aghsfort_magnataur_shockwave_mana_cost_cooldown",
		ability_name = "aghsfort_magnataur_shockwave",
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
		 description = "aghsfort_magnataur_shockwave_flat_shock_width",
		 ability_name = "aghsfort_magnataur_shockwave",
		 special_value_name = "shock_width",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 50,
	},

	{
		 description = "aghsfort_magnataur_shockwave_flat_damage",
		 ability_name = "aghsfort_magnataur_shockwave",
		 special_value_name = "shock_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 75,
	},

	{
		 description = "aghsfort_magnataur_shockwave_flat_slow_duration",
		 ability_name = "aghsfort_magnataur_shockwave",
		 special_value_name = "basic_slow_duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1.25,
	},


	{
		description = "aghsfort_magnataur_empower_flat_damage",
		ability_name = "aghsfort_magnataur_empower",
		special_value_name = "bonus_damage_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 5,
	},

	{
		description = "aghsfort_magnataur_empower_flat_cleave",
		ability_name = "aghsfort_magnataur_empower",
		special_value_name = "cleave_damage_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
	},

	{
		description = "aghsfort_magnataur_empower_width_distance",
		ability_name = "aghsfort_magnataur_empower",
		special_values =
		{
			{
				special_value_name = "cleave_ending_width",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 50,
			},
			{
				special_value_name = "cleave_distance",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 50,
			},
		},
	},

	{
		description = "aghsfort_magnataur_skewer_mana_cost_cooldown",
		ability_name = "aghsfort_magnataur_skewer",
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
		description = "aghsfort_magnataur_skewer_flat_range_speed",
		ability_name = "aghsfort_magnataur_skewer",
		special_values =
		{
			{
				special_value_name = "range",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 200,
			},
			{
				special_value_name = "skewer_speed",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 200,
			},
		},
	},

	{
		description = "aghsfort_magnataur_skewer_flat_damage",
		ability_name = "aghsfort_magnataur_skewer",
		special_value_name = "skewer_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 85,
	},

	{
		description = "aghsfort_magnataur_reverse_polarity_mana_cost_cooldown",
		ability_name = "aghsfort_magnataur_reverse_polarity",
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
		description = "aghsfort_magnataur_reverse_polarity_flat_damage",
		ability_name = "aghsfort_magnataur_reverse_polarity",
		special_value_name = "polarity_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 225,
	},

	{
		description = "aghsfort_magnataur_reverse_polarity_flat_stun_duration",
		ability_name = "aghsfort_magnataur_reverse_polarity",
		special_value_name = "hero_stun_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.5,
	},

	{
		description = "aghsfort_magnataur_reverse_polarity_flat_radius",
		ability_name = "aghsfort_magnataur_reverse_polarity",
		special_value_name = "pull_radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 120,
	},
}

return Magnus
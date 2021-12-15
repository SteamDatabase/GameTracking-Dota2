local Disruptor =
{
	{
		description = "aghsfort_disruptor_thunder_strike_mana_cost_cooldown",
		ability_name = "aghsfort_disruptor_thunder_strike",
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
		 description = "aghsfort_disruptor_thunder_strike_flat_radius",
		 ability_name = "aghsfort_disruptor_thunder_strike",
		 special_value_name = "radius",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 60,
	},

	{
		 description = "aghsfort_disruptor_thunder_strike_flat_strikes",
		 ability_name = "aghsfort_disruptor_thunder_strike",
		 special_value_name = "strikes",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
	},

	{
		 description = "aghsfort_disruptor_thunder_strike_flat_strike_damage",
		 ability_name = "aghsfort_disruptor_thunder_strike",
		 special_value_name = "strike_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 35,
	},

	{
		description = "aghsfort_disruptor_glimpse_mana_cost_cooldown",
		ability_name = "aghsfort_disruptor_glimpse",
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
		 description = "aghsfort_disruptor_glimpse_flat_cast_radius",
		 ability_name = "aghsfort_disruptor_glimpse",
		 special_value_name = "cast_radius",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 75,
	},

	{
		 description = "aghsfort_disruptor_glimpse_flat_bonus_damage",
		 ability_name = "aghsfort_disruptor_glimpse",
		 special_value_name = "bonus_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 30,
	},

	{
		description = "aghsfort_disruptor_kinetic_field_mana_cost_cooldown",
		ability_name = "aghsfort_disruptor_kinetic_field",
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
		description = "aghsfort_disruptor_kinetic_field_flat_duration",
		ability_name = "aghsfort_disruptor_kinetic_field",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.5,
	},

	{
		description = "aghsfort_disruptor_kinetic_field_formation_time",
		ability_name = "aghsfort_disruptor_kinetic_field",
		special_value_name = "formation_time",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = -20,
	},

	{
		description = "aghsfort_disruptor_static_storm_mana_cost_cooldown",
		ability_name = "aghsfort_disruptor_static_storm",
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
		description = "aghsfort_disruptor_static_storm_flat_duration",
		ability_name = "aghsfort_disruptor_static_storm",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.25,
	},

	{
		description = "aghsfort_disruptor_static_storm_flat_radius",
		ability_name = "aghsfort_disruptor_static_storm",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 125,
	},

	{
		description = "aghsfort_disruptor_static_storm_flat_damage_max",
		ability_name = "aghsfort_disruptor_static_storm",
		special_value_name = "damage_max",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 75,
	},
}

return Disruptor
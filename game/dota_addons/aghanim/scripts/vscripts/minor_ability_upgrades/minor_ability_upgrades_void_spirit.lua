local VoidSpirit =
{
	-- Aether Remnant
	{
		description = "aghsfort_void_spirit_aether_remnant_mana_cost_cooldown",
		ability_name = "aghsfort_void_spirit_aether_remnant",
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
		 description = "aghsfort_void_spirit_aether_remnant_damage",
		 ability_name = "aghsfort_void_spirit_aether_remnant",
		 special_value_name = "impact_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 100,
	},

	-- Dissimilate
	{
		description = "aghsfort_void_spirit_dissimilate_mana_cost_cooldown",
		ability_name = "aghsfort_void_spirit_dissimilate",
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
		 description = "aghsfort_void_spirit_dissimilate_damage",
		 ability_name = "aghsfort_void_spirit_dissimilate",
		 special_value_name = "damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 90,
	},

	--Resonant Pulse
	{
		description = "aghsfort_void_spirit_resonant_pulse_mana_cost_cooldown",
		ability_name = "aghsfort_void_spirit_resonant_pulse",
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
			{		
				special_value_name = "AbilityChargeRestoreTime",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			}
		},
	},

	{
		 description = "aghsfort_void_spirit_resonant_pulse_damage",
		 ability_name = "aghsfort_void_spirit_resonant_pulse",
		 special_value_name = "damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 50,
	},

	{
		 description = "aghsfort_void_spirit_resonant_pulse_base_absorb",
		 ability_name = "aghsfort_void_spirit_resonant_pulse",
		 special_value_name = "base_absorb_amount",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 100,
	},

	{
		 description = "aghsfort_void_spirit_resonant_pulse_absorb_per_unit",
		 ability_name = "aghsfort_void_spirit_resonant_pulse",
		 special_value_name = "absorb_per_unit_hit",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 20,
	},

	-- Astral Step

	{
		 description = "aghsfort_void_spirit_astral_step_pop_damage",
		 ability_name = "aghsfort_void_spirit_astral_step",
		 special_value_name = "pop_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 70,
	},

	{
		 description = "aghsfort_void_spirit_astral_step_max_travel_distance",
		 ability_name = "aghsfort_void_spirit_astral_step",
		 special_value_name = "max_travel_distance",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 125,
	},

	{
		 description = "aghsfort_void_spirit_astral_step_charge_restore_time",
		 ability_name = "aghsfort_void_spirit_astral_step",
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
			{		
				special_value_name = "AbilityChargeRestoreTime",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			}
		},
	},
}

return VoidSpirit

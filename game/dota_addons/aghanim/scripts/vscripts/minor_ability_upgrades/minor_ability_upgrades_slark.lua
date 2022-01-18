local Slark =
{
	{
		description = "aghsfort_slark_dark_pact_mana_cost_cooldown",
		ability_name = "aghsfort_slark_dark_pact",
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
		description = "aghsfort_slark_pounce_mana_cost_cooldown",
		ability_name = "aghsfort_slark_pounce",
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
		description = "aghsfort_slark_essence_shift_mana_cost_cooldown",
		ability_name = "aghsfort_slark_essence_shift",
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
		description = "aghsfort_slark_shadow_dance_mana_cost_cooldown",
		ability_name = "aghsfort_slark_shadow_dance",
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
		 description = "aghsfort_slark_dark_pact_total_damage",
		 ability_name = "aghsfort_slark_dark_pact",
		 special_value_name = "total_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 100,
	},
	{
		 description = "aghsfort_slark_dark_pact_heal_pct",
		 ability_name = "aghsfort_slark_dark_pact",
		 special_value_name = "heal_pct",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 2.5,
	},

	{
		 description = "aghsfort_slark_pounce_distance_speed",
		 ability_name = "aghsfort_slark_pounce",
		 special_values =
		 {
			{
				special_value_name = "pounce_distance",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 150,
			},
			{
				special_value_name = "pounce_speed",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 150,
			},
		},
	},

	{
		 description = "aghsfort_slark_pounce_leash_duration",
		 ability_name = "aghsfort_slark_pounce",
		 special_value_name = "leash_duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
	},	
	{
		 description = "aghsfort_slark_pounce_damage",
		 ability_name = "aghsfort_slark_pounce",
		 special_value_name = "pounce_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 75,
	},	
	{
		 description = "aghsfort_slark_essence_shift_agi_gain",
		 ability_name = "aghsfort_slark_essence_shift",
		 special_value_name = "agi_gain",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
	},
	{
		 description = "aghsfort_slark_essence_shift_active_duration",
		 ability_name = "aghsfort_slark_essence_shift",
		 special_value_name = "active_duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
	},	
	{
		 description = "aghsfort_slark_essence_shift_max_stacks",
		 ability_name = "aghsfort_slark_essence_shift",
		 special_value_name = "max_stacks",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 5,
	},	
	{
		 description = "aghsfort_slark_shadow_dance_duration",
		 ability_name = "aghsfort_slark_shadow_dance",
		 special_value_name = "duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1.0,
	},		
	{
		 description = "aghsfort_slark_shadow_dance_bonus_movement_speed",
		 ability_name = "aghsfort_slark_shadow_dance",
		 special_value_name = "bonus_movement_speed",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 25,
	},	
	{
		 description = "aghsfort_slark_shadow_dance_bonus_bonus_regen_pct",
		 ability_name = "aghsfort_slark_shadow_dance",
		 special_value_name = "bonus_regen_pct",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 2,
	},	
}

return Slark
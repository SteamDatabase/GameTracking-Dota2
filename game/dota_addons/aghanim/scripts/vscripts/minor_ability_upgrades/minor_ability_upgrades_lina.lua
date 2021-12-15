local Lina =
{
	{
		description = "aghsfort_lina_dragon_slave_mana_cost_cooldown",
		ability_name = "aghsfort_lina_dragon_slave",
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
		 description = "aghsfort_lina_dragon_slave_damage",
		 ability_name = "aghsfort_lina_dragon_slave",
		 special_value_name = "dragon_slave_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 75,
	},
	{
		 description = "aghsfort_lina_dragon_slave_distance",
		 ability_name = "aghsfort_lina_dragon_slave",
		 special_value_name = "dragon_slave_distance",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 150,
	},	
	{
		description = "aghsfort_lina_light_strike_array_mana_cost_cooldown",
		ability_name = "aghsfort_lina_light_strike_array",
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
		 description = "aghsfort_lina_light_strike_array_aoe",
		 ability_name = "aghsfort_lina_light_strike_array",
		 special_value_name = "light_strike_array_aoe",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 50,
	},
	{
		 description = "aghsfort_lina_light_strike_array_damage",
		 ability_name = "aghsfort_lina_light_strike_array",
		 special_value_name = "light_strike_array_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 70,
	},
	{
		 description = "aghsfort_lina_light_strike_array_stun",
		 ability_name = "aghsfort_lina_light_strike_array",
		 special_value_name = "light_strike_array_stun_duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 0.4,
	},
	{
		description = "aghsfort_lina_fiery_soul_mana_cost_cooldown",
		ability_name = "aghsfort_lina_fiery_soul",
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
 		description = "aghsfort_lina_fiery_soul_attack_speed",
		 ability_name = "aghsfort_lina_fiery_soul",
		 special_value_name = "fiery_soul_attack_speed_bonus",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 20,
	},
	{
 		description = "aghsfort_lina_fiery_soul_max_stacks",
		 ability_name = "aghsfort_lina_fiery_soul",
		 special_value_name = "fiery_soul_max_stacks",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
	},
	{
 		description = "aghsfort_lina_fiery_soul_active_duration",
		 ability_name = "aghsfort_lina_fiery_soul",
		 special_value_name = "active_duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 2,
	},
	{
 		description = "aghsfort_lina_fiery_soul_fiery_soul_stack_duration",
		 ability_name = "aghsfort_lina_fiery_soul",
		 special_value_name = "fiery_soul_stack_duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 3,
	},

	{
 		description = "aghsfort_lina_fiery_soul_move_speed",
		 ability_name = "aghsfort_lina_fiery_soul",
		 special_value_name = "fiery_soul_move_speed_bonus",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 2,
	},
	{
		description = "aghsfort_lina_laguna_blade_mana_cost_cooldown",
		ability_name = "aghsfort_lina_laguna_blade",
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
 		description = "aghsfort_lina_laguna_blade_damage",
		 ability_name = "aghsfort_lina_laguna_blade",
		 special_value_name = "damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 200,
	},

}

return Lina

local Viper =
{
	{
		 description = "aghsfort_viper_poison_attack_pct_mana_cost",
		 ability_name = "aghsfort_viper_poison_attack",
		 special_value_name = "mana_cost",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 15,
	},

	{
		 description = "aghsfort_viper_poison_attack_damage",
		 ability_name = "aghsfort_viper_poison_attack",
		 special_value_name = "damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 6,
	},

	{
		 description = "aghsfort_viper_poison_attack_magic_resistance",
		 ability_name = "aghsfort_viper_poison_attack",
		 special_value_name = "magic_resistance",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
	},

	{
		 description = "aghsfort_viper_poison_attack_duration",
		 ability_name = "aghsfort_viper_poison_attack",
		 special_value_name = "duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
	},

	{
		 description = "aghsfort_viper_poison_attack_max_stacks",
		 ability_name = "aghsfort_viper_poison_attack",
		 special_value_name = "max_stacks",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
	},

	{
		description = "aghsfort_viper_nethertoxin_mana_cost_cooldown",
		ability_name = "aghsfort_viper_nethertoxin",
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
		 description = "aghsfort_viper_nethertoxin_max_damage",
		 ability_name = "aghsfort_viper_nethertoxin",
		 special_value_name = "max_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 40,
	},

	{
		 description = "aghsfort_viper_nethertoxin_radius",
		 ability_name = "aghsfort_viper_nethertoxin",
		 special_value_name = "radius",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 100,
	},

	{
		 description = "aghsfort_viper_nethertoxin_duration",
		 ability_name = "aghsfort_viper_nethertoxin",
		 special_value_name = "duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 2,
	},

	{
		 description = "aghsfort_viper_corrosive_skin_bonus_attack_speed",
		 ability_name = "aghsfort_viper_corrosive_skin",
		 special_value_name = "bonus_attack_speed",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 12,
	},

	{
		 description = "aghsfort_viper_corrosive_skin_bonus_magic_resistance",
		 ability_name = "aghsfort_viper_corrosive_skin",
		 special_value_name = "bonus_magic_resistance",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 5,
	},

	{
		 description = "aghsfort_viper_corrosive_skin_damage",
		 ability_name = "aghsfort_viper_corrosive_skin",
		 special_value_name = "damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 12,
	},

	{
		 description = "aghsfort_viper_corrosive_skin_duration",
		 ability_name = "aghsfort_viper_corrosive_skin",
		 special_value_name = "duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 4,
	},

	{
		description = "aghsfort_viper_viper_strike_mana_cost_cooldown",
		ability_name = "aghsfort_viper_viper_strike",
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
		 description = "aghsfort_viper_viper_strike_duration",
		 ability_name = "aghsfort_viper_viper_strike",
		 special_value_name = "duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1.2,
	},

	{
		 description = "aghsfort_viper_viper_strike_damage",
		 ability_name = "aghsfort_viper_viper_strike",
		 special_value_name = "damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 40,
	},

}

return Viper
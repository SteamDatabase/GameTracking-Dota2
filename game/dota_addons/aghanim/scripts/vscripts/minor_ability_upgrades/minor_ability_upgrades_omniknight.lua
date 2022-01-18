local Omniknight =
{
	{
		description = "aghsfort_omniknight_purification_mana_cost_cooldown",
		ability_name = "aghsfort_omniknight_purification",
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
		 description = "aghsfort_omniknight_purification_flat_heal",
		 ability_name = "aghsfort_omniknight_purification",
		 special_value_name = "heal",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 40,
	},
	{
		 description = "aghsfort_omniknight_purification_flat_cast_range",
		 ability_name = "aghsfort_omniknight_purification",
		 special_value_name = "cast_range",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 100,
	},

	{
		 description = "aghsfort_omniknight_purification_flat_radius",
		 ability_name = "aghsfort_omniknight_purification",
		 special_value_name = "radius",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 80,
	},

	{
		description = "aghsfort_omniknight_repel_mana_cost_cooldown",
		ability_name = "aghsfort_omniknight_repel",
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
		 description = "aghsfort_omniknight_repel_flat_duration",
		 ability_name = "aghsfort_omniknight_repel",
		 special_value_name = "duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
	},

	{
		 description = "aghsfort_omniknight_repel_flat_damage_reduction",
		 ability_name = "aghsfort_omniknight_repel",
		 special_value_name = "damage_reduction",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 6,
	},

	{
		 description = "aghsfort_omniknight_repel_flat_bonus_str",
		 ability_name = "aghsfort_omniknight_repel",
		 special_value_name = "bonus_str",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 7,
	},

	{
		 description = "aghsfort_omniknight_repel_flat_hp_regen",
		 ability_name = "aghsfort_omniknight_repel",
		 special_value_name = "hp_regen",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 6,
	},

	{
		 description = "aghsfort_omniknight_degen_aura_flat_radius",
		 ability_name = "aghsfort_omniknight_degen_aura",
		 special_value_name = "radius",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 75,
	},

	{
		 description = "aghsfort_omniknight_degen_aura_flat_move_speed_bonus",
		 ability_name = "aghsfort_omniknight_degen_aura",
		 special_value_name = "move_speed_bonus",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 8,
	},
	{
		 description = "aghsfort_omniknight_degen_aura_flat_attack_speed_bonus",
		 ability_name = "aghsfort_omniknight_degen_aura",
		 special_value_name = "attack_speed_bonus",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 8,
	},

	{
		description = "aghsfort_omniknight_guardian_angel_mana_cost_cooldown",
		ability_name = "aghsfort_omniknight_guardian_angel",
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
		 description = "aghsfort_omniknight_guardian_angel_flat_duration",
		 ability_name = "aghsfort_omniknight_guardian_angel",
		 special_value_name = "duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1.5,
	},

	{
		 description = "aghsfort_omniknight_guardian_angel_flat_radius",
		 ability_name = "aghsfort_omniknight_guardian_angel",
		 special_value_name = "radius",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 200,
	},

	{
		 description = "aghsfort_omniknight_guardian_angel_flat_hp_regen",
		 ability_name = "aghsfort_omniknight_guardian_angel",
		 special_value_name = "hp_regen",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 12,
	},

}

return Omniknight
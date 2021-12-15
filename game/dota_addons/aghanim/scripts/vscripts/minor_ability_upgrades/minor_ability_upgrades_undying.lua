local Undying =
{
	{
		 description = "aghsfort_undying_decay_str_steal",
		 ability_name = "aghsfort_undying_decay",
		 special_value_name = "str_steal",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 0.2,
	},
	{
		 description = "aghsfort_undying_decay_radius",
		 ability_name = "aghsfort_undying_decay",
		 special_value_name = "radius",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 40,
	},
	{
		 description = "aghsfort_undying_decay_decay_damage",
		 ability_name = "aghsfort_undying_decay",
		 special_value_name = "decay_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 30,
	},	
	{
		description = "aghsfort_undying_decay_percent_mana_cost_cooldown",
		ability_name = "aghsfort_undying_decay",
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
		 description = "aghsfort_undying_soul_rip_damage_per_unit",
		 ability_name = "aghsfort_undying_soul_rip",
		 special_value_name = "damage_per_unit",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 4,
	},
	{
		 description = "aghsfort_undying_soul_rip_max_units",
		 ability_name = "aghsfort_undying_soul_rip",
		 special_value_name = "max_units",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 2,
	},
	{
		 description = "aghsfort_undying_soul_rip_percent_mana_cost_cooldown",
		 ability_name = "aghsfort_undying_soul_rip",
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
		 description = "aghsfort_undying_tombstone_zombie_base_damage",
		 ability_name = "aghsfort_undying_tombstone",
		 special_value_name = "zombie_base_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 4,
	},
	{
		 description = "aghsfort_undying_tombstone_duration",
		 ability_name = "aghsfort_undying_tombstone",
		 special_value_name = "duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 5,
	},
	{
		 description = "aghsfort_undying_tombstone_percent_mana_cost_cooldown",
		 ability_name = "aghsfort_undying_tombstone",
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
		 description = "aghsfort_undying_flesh_golem_str_percentage",
		 ability_name = "aghsfort_undying_flesh_golem",
		 special_value_name = "str_percentage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 5,
	},
	{
		 description = "aghsfort_undying_flesh_golem_duration",
		 ability_name = "aghsfort_undying_flesh_golem",
		 special_value_name = "duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 8,
	},
	{
		 description = "aghsfort_undying_flesh_golem_damage_amp",
		 ability_name = "aghsfort_undying_flesh_golem",
		 special_value_name = "damage_amp",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 5,
	},
	{
		description = "aghsfort_undying_flesh_golem_percent_mana_cost_cooldown",
		ability_name = "aghsfort_undying_flesh_golem",
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

}

return Undying

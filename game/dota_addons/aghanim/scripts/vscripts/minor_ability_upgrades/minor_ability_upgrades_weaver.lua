local Weaver =
{

	{
		 description = "aghsfort_weaver_the_swarm_flat_damage",
		 ability_name = "aghsfort_weaver_the_swarm",
		 special_value_name = "damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 12,
	},

	{
		description = "aghsfort_weaver_the_swarm_mana_cost_cooldown",
		ability_name = "aghsfort_weaver_the_swarm",
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
		 description = "aghsfort_weaver_the_swarm_flat_count",
		 ability_name = "aghsfort_weaver_the_swarm",
		 special_value_name = "count",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 2,
	},
	{
		 description = "aghsfort_weaver_the_swarm_flat_armor_reduction",
		 ability_name = "aghsfort_weaver_the_swarm",
		 special_value_name = "armor_reduction",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 0.5,
	},
	{
		 description = "aghsfort_weaver_the_swarm_flat_duration",
		 ability_name = "aghsfort_weaver_the_swarm",
		 special_value_name = "duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 2,
	},
	{
		 description = "aghsfort_weaver_the_swarm_flat_destroy_attacks",
		 ability_name = "aghsfort_weaver_the_swarm",
		 special_value_name = "destroy_attacks",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
	},

	{
		 description = "aghsfort_weaver_shukuchi_flat_damage",
		 ability_name = "aghsfort_weaver_shukuchi",
		 special_value_name = "damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 50,
	},

	{
		 description = "aghsfort_weaver_shukuchi_flat_speed",
		 ability_name = "aghsfort_weaver_shukuchi",
		 special_value_name = "speed",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 30,
	},

	{
		 description = "aghsfort_weaver_shukuchi_duration",
		 ability_name = "aghsfort_weaver_shukuchi",
		 special_value_name = "duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
	},
	{
		 description = "aghsfort_weaver_shukuchi_radius",
		 ability_name = "aghsfort_weaver_shukuchi",
		 special_value_name = "radius",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 35,
	},

	{
		 description = "aghsfort_weaver_geminate_attack_cooldown",
		 ability_name = "aghsfort_weaver_geminate_attack",
		 special_value_name = "cooldown",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 12,
	},
	{
		 description = "aghsfort_weaver_geminate_attack_flat_bonus_damage",
		 ability_name = "aghsfort_weaver_geminate_attack",
		 special_value_name = "bonus_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 20,
	},

	{
		description = "aghsfort_weaver_shukuchi_mana_cost_cooldown",
		ability_name = "aghsfort_weaver_shukuchi",
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
		description = "aghsfort_weaver_time_lapse_mana_cost_cooldown",
		ability_name = "aghsfort_weaver_time_lapse",
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

return Weaver
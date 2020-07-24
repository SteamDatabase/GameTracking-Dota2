local WinterWyvern =
{
	{
		 description = "aghsfort_winter_wyvern_arctic_burn_flat_damage",
		 ability_name = "aghsfort_winter_wyvern_arctic_burn",
		 special_value_name = "damage_per_second",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 20,
	},

	{
		 description = "aghsfort_winter_wyvern_arctic_burn_flat_duration",
		 ability_name = "aghsfort_winter_wyvern_arctic_burn",
		 special_value_name = "duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1.0,
	},

	{
		 description = "aghsfort_winter_wyvern_arctic_burn_flat_range",
		 ability_name = "aghsfort_winter_wyvern_arctic_burn",
		 special_value_name = "attack_range_bonus",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 150,
	},

	{
		 description = "aghsfort_winter_wyvern_arctic_burn_flat_move_slow",
		 ability_name = "aghsfort_winter_wyvern_arctic_burn",
		 special_value_name = "move_slow",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 25,
	},

	{
		 description = "aghsfort_winter_wyvern_splinter_blast_flat_slow",
		 ability_name = "aghsfort_winter_wyvern_splinter_blast",
		 special_value_name = "bonus_movespeed",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 25,
	},

	{
		 description = "aghsfort_winter_wyvern_splinter_blast_flat_radius",
		 ability_name = "aghsfort_winter_wyvern_splinter_blast",
		 special_value_name = "split_radius",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 125,
	},

	{
		 description = "aghsfort_winter_wyvern_splinter_blast_flat_slow_duration",
		 ability_name = "aghsfort_winter_wyvern_splinter_blast",
		 special_value_name = "duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 2.0,
	},

	{
		 description = "aghsfort_winter_wyvern_splinter_blast_flat_damage",
		 ability_name = "aghsfort_winter_wyvern_splinter_blast",
		 special_value_name = "splinter_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 100,
	},

	-- {
	-- 	 description = "aghsfort_winter_wyvern_splinter_blast_pct_mana_cost",
	-- 	 ability_name = "aghsfort_winter_wyvern_splinter_blast",
	-- 	 special_value_name = "mana_cost",
	-- 	 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
	-- 	 value = 15,
	-- },

	{
		 description = "aghsfort_winter_wyvern_splinter_blast_pct_cooldown",
		 ability_name = "aghsfort_winter_wyvern_splinter_blast",
		 special_value_name = "cooldown",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 12,
	},

	{
		 description = "aghsfort_winter_wyvern_cold_embrace_pct_cooldown",
		 ability_name = "aghsfort_winter_wyvern_cold_embrace",
		 special_value_name = "cooldown",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 12,
	},

	{
		 description = "aghsfort_winter_wyvern_cold_embrace_flat_heal_additive",
		 ability_name = "aghsfort_winter_wyvern_cold_embrace",
		 special_value_name = "heal_additive",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 12,
	},

	{
		 description = "aghsfort_winter_wyvern_cold_embrace_flat_heal_percentage",
		 ability_name = "aghsfort_winter_wyvern_cold_embrace",
		 special_value_name = "heal_percentage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1.0,
	},

	{
		 description = "aghsfort_winter_wyvern_cold_embrace_flat_duration",
		 ability_name = "aghsfort_winter_wyvern_cold_embrace",
		 special_value_name = "duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1.0,
	},


	{
		 description = "aghsfort_winter_wyvern_winters_curse_pct_cooldown",
		 ability_name = "aghsfort_winter_wyvern_winters_curse",
		 special_value_name = "cooldown",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 12,
	},

	-- {
	-- 	 description = "aghsfort_winter_wyvern_winters_curse_pct_manacost",
	-- 	 ability_name = "aghsfort_winter_wyvern_winters_curse",
	-- 	 special_value_name = "mana_cost",
	-- 	 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
	-- 	 value = 15,
	-- },

	{
		 description = "aghsfort_winter_wyvern_winters_curse_flat_bonus_attack_speed",
		 ability_name = "aghsfort_winter_wyvern_winters_curse",
		 special_value_name = "bonus_attack_speed",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 25,
	},

	{
		 description = "aghsfort_winter_wyvern_winters_curse_flat_duration",
		 ability_name = "aghsfort_winter_wyvern_winters_curse",
		 special_value_name = "duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1.5,
	},

	{
		 description = "aghsfort_winter_wyvern_winters_curse_flat_radius",
		 ability_name = "aghsfort_winter_wyvern_winters_curse",
		 special_value_name = "radius",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 125,
	},
}

return WinterWyvern
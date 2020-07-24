local Magnus =
{
	{
		 description = "aghsfort_magnataur_shockwave_flat_damage",
		 ability_name = "aghsfort_magnataur_shockwave",
		 special_value_name = "shock_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 75,
	},
	-- {
	-- 	 description = "aghsfort_magnataur_shockwave_flat_shock_width",
	-- 	 ability_name = "aghsfort_magnataur_shockwave",
	-- 	 special_value_name = "shock_width",
	-- 	 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	-- 	 value = 50,
	-- },

	{
		 description = "aghsfort_magnataur_shockwave_flat_slow_duration",
		 ability_name = "aghsfort_magnataur_shockwave",
		 special_value_name = "basic_slow_duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1.25,
	},

	{
		 description = "aghsfort_magnataur_shockwave_pct_mana_cost",
		 ability_name = "aghsfort_magnataur_shockwave",
		 special_value_name = "mana_cost",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 15,
	},
	{
		 description = "aghsfort_magnataur_shockwave_pct_cooldown",
		 ability_name = "aghsfort_magnataur_shockwave",
		 special_value_name = "cooldown",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 12,
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
		description = "aghsfort_magnataur_skewer_flat_range",
		ability_name = "aghsfort_magnataur_skewer",
		special_value_name = "range",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 200,
	},

	{
		description = "aghsfort_magnataur_skewer_flat_damage",
		ability_name = "aghsfort_magnataur_skewer",
		special_value_name = "skewer_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 85,
	},

	-- {
	-- 	description = "aghsfort_magnataur_skewer_flat_slow_pct",
	-- 	ability_name = "aghsfort_magnataur_skewer",
	-- 	special_value_name = "slow_pct",
	-- 	operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	-- 	value = 25,
	-- },

	{
		description = "aghsfort_magnataur_skewer_pct_cooldown",
		ability_name = "aghsfort_magnataur_skewer",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},

	{
		description = "aghsfort_magnataur_reverse_polarity_pct_cooldown",
		ability_name = "aghsfort_magnataur_reverse_polarity",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},

	-- {
	-- 	description = "aghsfort_magnataur_reverse_polarity_pct_mana_cost",
	-- 	ability_name = "aghsfort_magnataur_reverse_polarity",
	-- 	special_value_name = "mana_cost",
	-- 	operator = MINOR_ABILITY_UPGRADE_OP_MUL,
	-- 	value = 15,
	-- },

	{
		description = "aghsfort_magnataur_reverse_polarity_flat_damage",
		ability_name = "aghsfort_magnataur_reverse_polarity",
		special_value_name = "polarity_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 150,
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
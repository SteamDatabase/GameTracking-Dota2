local Dawnbreaker =
{
	{
		description = "aghsfort_dawnbreaker_fire_wreath_debuff_duration",
		ability_name = "aghsfort_dawnbreaker_fire_wreath",
		special_values =
		{
			{
				special_value_name = "smash_stun_duration",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 0.5,
			},
			{
				special_value_name = "sweep_stun_duration",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 0.5,
			},
		},
	},

	-- {
	-- 	description = "aghsfort_dawnbreaker_fire_wreath_movement_speed",
	-- 	ability_name = "aghsfort_dawnbreaker_fire_wreath",
	-- 	special_value_name = "movement_speed",
	-- 	operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	-- 	value = 50,
	-- },

	{
		description = "aghsfort_dawnbreaker_fire_wreath_swipe_smash_radius",
		ability_name = "aghsfort_dawnbreaker_fire_wreath",
		special_values =
		{
			{
				special_value_name = "swipe_radius",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 40,
			},
			{
				special_value_name = "smash_radius",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 25,
			},
		},
	},

	{
		description = "aghsfort_dawnbreaker_fire_wreath_swipe_smash_damage",
		ability_name = "aghsfort_dawnbreaker_fire_wreath",
		special_values =
		{
			{
				special_value_name = "swipe_damage",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 10,
			},
			{
				special_value_name = "smash_damage",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 25,
			},
		},
	},


	{
		description = "aghsfort_dawnbreaker_fire_wreath_mana_cost_cooldown",
		ability_name = "aghsfort_dawnbreaker_fire_wreath",
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
		description = "aghsfort_dawnbreaker_celestial_hammer_hammer_damage",
		ability_name = "aghsfort_dawnbreaker_celestial_hammer",
		special_value_name = "hammer_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 45,
	},

	{
		description = "aghsfort_dawnbreaker_celestial_hammer_burn_damage",
		ability_name = "aghsfort_dawnbreaker_celestial_hammer",
		special_value_name = "burn_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 12,
	},

	{
		description = "aghsfort_dawnbreaker_celestial_hammer_range",
		ability_name = "aghsfort_dawnbreaker_celestial_hammer",
		special_value_name = "range",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 200,
	},

	{
		description = "aghsfort_dawnbreaker_celestial_hammer_fire_trail_duration",
		ability_name = "aghsfort_dawnbreaker_celestial_hammer",
		special_value_name = "flare_debuff_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.8,
	},

	{
		description = "aghsfort_dawnbreaker_celestial_hammer_mana_cost_cooldown",
		ability_name = "aghsfort_dawnbreaker_celestial_hammer",
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
		description = "aghsfort_dawnbreaker_luminosity_bonus_damage",
		ability_name = "aghsfort_dawnbreaker_luminosity",
		special_value_name = "bonus_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 20,
	},

	{
		description = "aghsfort_dawnbreaker_luminosity_heal_pct",
		ability_name = "aghsfort_dawnbreaker_luminosity",
		special_value_name = "heal_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 3,
	},

	{
		description = "aghsfort_dawnbreaker_luminosity_heal_radius",
		ability_name = "aghsfort_dawnbreaker_luminosity",
		special_value_name = "heal_radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 150,
	},

	-- {
	-- 	description = "aghsfort_dawnbreaker_luminosity_allied_healing_pct",
	-- 	ability_name = "aghsfort_dawnbreaker_luminosity",
	-- 	special_value_name = "allied_healing_pct",
	-- 	operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	-- 	value = 7,
	-- },

	{
		description = "aghsfort_dawnbreaker_solar_guardian_radius",
		ability_name = "aghsfort_dawnbreaker_solar_guardian",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 150,
	},

	{
		description = "aghsfort_dawnbreaker_solar_guardian_damage",
		ability_name = "aghsfort_dawnbreaker_solar_guardian",
		special_values =
		{
			{
				special_value_name = "base_damage",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 30,
			},
			{
				special_value_name = "land_damage",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 150,
			},
		},
	},

	{
		description = "aghsfort_dawnbreaker_solar_guardian_base_heal",
		ability_name = "aghsfort_dawnbreaker_solar_guardian",
		special_value_name = "base_heal",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 20,
	},

	{
		description = "aghsfort_dawnbreaker_solar_guardian_mana_cost_cooldown",
		ability_name = "aghsfort_dawnbreaker_solar_guardian",
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

return Dawnbreaker

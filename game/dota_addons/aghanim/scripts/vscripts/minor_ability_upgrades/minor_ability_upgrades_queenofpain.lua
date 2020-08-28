local QueenOfPain =
{
	{
		 description = "aghsfort_queenofpain_shadow_strike_percent_cooldown",
		 ability_name = "aghsfort_queenofpain_shadow_strike",
		 special_value_name = "cooldown",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 12,
	},
	{
		 description = "aghsfort_queenofpain_shadow_strike_dot_damage",
		 ability_name = "aghsfort_queenofpain_shadow_strike",
		 special_value_name = "duration_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 30,
	},
	{
		 description = "aghsfort_queenofpain_shadow_strike_strike_damage",
		 ability_name = "aghsfort_queenofpain_shadow_strike",
		 special_value_name = "strike_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 100,
	},	
	{
		 description = "aghsfort_queenofpain_blink_percent_cooldown",
		 ability_name = "aghsfort_queenofpain_blink",
		 special_value_name = "cooldown",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 12,
	},
	{
		 description = "aghsfort_queenofpain_blink_range",
		 ability_name = "aghsfort_queenofpain_blink",
		 special_value_name = "blink_range",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 200,
	},
	{
		 description = "aghsfort_queenofpain_scream_of_pain_percent_cooldown",
		 ability_name = "aghsfort_queenofpain_scream_of_pain",
		 special_value_name = "cooldown",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 12,
	},
	{
		 description = "aghsfort_queenofpain_scream_of_pain_damage",
		 ability_name = "aghsfort_queenofpain_scream_of_pain",
		 special_value_name = "damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 75,
	},
	{
		 description = "aghsfort_queenofpain_scream_of_pain_radius",
		 ability_name = "aghsfort_queenofpain_scream_of_pain",
		 special_value_name = "area_of_effect",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 75,
	},
	{
		 description = "aghsfort_queenofpain_sonic_wave_percent_cooldown",
		 ability_name = "aghsfort_queenofpain_sonic_wave",
		 special_value_name = "cooldown",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 12,
	},
	{
		 description = "aghsfort_queenofpain_sonic_wave_damage",
		 ability_name = "aghsfort_queenofpain_sonic_wave",
		 special_value_name = "damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 110,
	},
	{
		 description = "aghsfort_queenofpain_sonic_wave_distance",
		 ability_name = "aghsfort_queenofpain_sonic_wave",
		 special_value_name = "distance",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 100,
	},
	{
		 description = "aghsfort_queenofpain_sonic_wave_knockback_duration",
		 ability_name = "aghsfort_queenofpain_sonic_wave",
		 special_value_name = "knockback_duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1.0,
	},			
}

return QueenOfPain

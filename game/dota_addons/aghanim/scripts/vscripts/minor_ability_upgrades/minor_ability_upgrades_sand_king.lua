local Sand_King =
{

	{
		description = "aghsfort_sand_king_sand_storm_mana_cost_cooldown",
		ability_name = "aghsfort_sand_king_sand_storm",
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
		description = "aghsfort_sand_king_epicenter_mana_cost_cooldown",
		ability_name = "aghsfort_sand_king_epicenter",
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
		description = "aghsfort_sand_king_burrowstrike_cost_cooldown",
		ability_name = "aghsfort_sand_king_burrowstrike",
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
		description = "aghsfort_sand_king_burrowstrike_damage",
		ability_name = "aghsfort_sand_king_burrowstrike",
		special_value_name = "damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 75,
	},

	{
		description = "aghsfort_sand_king_burrowstrike_burrow_duration",
		ability_name = "aghsfort_sand_king_burrowstrike",
		special_value_name = "burrow_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.75,
	},
	
	{
		description = "aghsfort_sand_king_burrowstrike_cast_range",
		ability_name = "aghsfort_sand_king_burrowstrike",
		special_value_name = "burrowstrike_cast_range",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 100,
	},
	{
		description = "aghsfort_sand_king_sand_storm_radius",
		ability_name = "aghsfort_sand_king_sand_storm",
		special_value_name = "sand_storm_radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},	
	{
		description = "aghsfort_sand_king_sand_storm_damage",
		ability_name = "aghsfort_sand_king_sand_storm",
		special_value_name = "sand_storm_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 25,
	},		
	{
		description = "aghsfort_sand_king_sandstorm_duration",
		ability_name = "aghsfort_sand_king_sand_storm",
		special_value_name = "sandstorm_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 2,
	},

	{
		description = "aghsfort_sand_king_sandstorm_blind_slow",
		ability_name = "aghsfort_sand_king_sand_storm",
		special_value_name = "blind_slow_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 5,
	},			

	{
		description = "aghsfort_sand_king_caustic_finale_radius",
		ability_name = "aghsfort_sand_king_caustic_finale",
		special_value_name = "caustic_finale_radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},		
	{
		description = "aghsfort_sand_king_caustic_finale_damage_death",
		ability_name = "aghsfort_sand_king_caustic_finale",
		special_value_name = "caustic_finale_damage_death",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},	
	{
		description = "aghsfort_sand_king_caustic_finale_damage_dot",
		ability_name = "aghsfort_sand_king_caustic_finale",
		special_value_name = "caustic_finale_damage_dot",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 8,
	},		
	{
		description = "aghsfort_sand_king_caustic_finale_duration",
		ability_name = "aghsfort_sand_king_caustic_finale",
		special_value_name = "caustic_finale_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 2,
	},
				
	{	
		description = "aghsfort_sand_king_epicenter_radius",
		ability_name = "aghsfort_sand_king_epicenter",
		special_value_name = "epicenter_radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 30,
	},	
	{	
		description = "aghsfort_sand_king_epicenter_pulses",
		ability_name = "aghsfort_sand_king_epicenter",
		special_value_name = "epicenter_pulses",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},	
	{	
		description = "aghsfort_sand_king_epicenter_damage",
		ability_name = "aghsfort_sand_king_epicenter",
		special_value_name = "epicenter_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 30,
	},		
	    
}

return Sand_King

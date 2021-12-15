local Gyrocopter =
{
	
	{
		description = "aghsfort_gyrocopter_rocket_barrage_mana_cost_cooldown",
		ability_name = "aghsfort_gyrocopter_rocket_barrage",
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
		 description = "aghsfort_gyrocopter_rocket_barrage_rocket_damage_upgrade",
		 ability_name = "aghsfort_gyrocopter_rocket_barrage",
		 special_value_name = "rocket_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 7,
	},
	{
		 description = "aghsfort_gyrocopter_rocket_barrage_radius_upgrade",
		 ability_name = "aghsfort_gyrocopter_rocket_barrage",
		 special_value_name = "radius",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 100,
	},
	{
		 description = "aghsfort_gyrocopter_rocket_barrage_duration_upgrade",
		 ability_name = "aghsfort_gyrocopter_rocket_barrage",
		 special_value_name = "duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
	},	
	{
		description = "aghsfort_gyrocopter_homing_missile_mana_cost_cooldown",
		ability_name = "aghsfort_gyrocopter_homing_missile",
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
		 description = "aghsfort_gyrocopter_homing_missile_damage_upgrade",
		 ability_name = "aghsfort_gyrocopter_homing_missile",
		 special_value_name = "damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 85,
	},	
	{
		 description = "aghsfort_gyrocopter_homing_missile_stun_duration_upgrade",
		 ability_name = "aghsfort_gyrocopter_homing_missile",
		 special_value_name = "stun_duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 0.5,
	},
	{
		description = "aghsfort_gyrocopter_flak_cannon_mana_cost_cooldown",
		ability_name = "aghsfort_gyrocopter_flak_cannon",
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
		 description = "aghsfort_gyrocopter_flak_cannon_max_attacks_upgrade",
		 ability_name = "aghsfort_gyrocopter_flak_cannon",
		 special_value_name = "max_attacks",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
	},	
	{
		 description = "aghsfort_gyrocopter_flak_cannon_max_targets_upgrade",
		 ability_name = "aghsfort_gyrocopter_flak_cannon",
		 special_value_name = "max_targets",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
	},	
	{
		description = "aghsfort_gyrocopter_call_down_mana_cost_cooldown",
		ability_name = "aghsfort_gyrocopter_call_down",
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
		 description = "aghsfort_gyrocopter_call_down_radius_upgrade",
		 ability_name = "aghsfort_gyrocopter_call_down",
		 special_value_name = "radius",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 50,
	},	
	{
		description = "aghsfort_gyrocopter_call_down_damage_upgrade",
		ability_name = "aghsfort_gyrocopter_call_down",
		special_values =
		{
			{
				special_value_name = "damage_first",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 100,
			},
			{
				special_value_name = "damage_second",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 100,
			},
		},		 
	},					
}
return Gyrocopter

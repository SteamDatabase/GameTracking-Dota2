local Lich =
{
	{
		 description = "aghsfort_lich_frost_nova_mana_cost_cooldown",
		 ability_name = "aghsfort_lich_frost_nova",
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
		 description = "aghsfort_lich_frost_nova_damage_upgrade",
		 ability_name = "aghsfort_lich_frost_nova",
		 special_value_name = "aoe_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 70,
	},
	{
		 description = "aghsfort_lich_frost_nova_radius_upgrade",
		 ability_name = "aghsfort_lich_frost_nova",
		 special_value_name = "radius",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 50,
	},
	{
		 description = "aghsfort_lich_frost_shield_duration_upgrade",
		 ability_name = "aghsfort_lich_frost_shield",
		 special_value_name = "duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
	},	
	{
		description = "aghsfort_lich_frost_shield_mana_cost_cooldown",
		ability_name = "aghsfort_lich_frost_shield",
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
		 description = "aghsfort_lich_frost_shield_damage_upgrade",
		 ability_name = "aghsfort_lich_frost_shield",
		 special_value_name = "damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 15,
	},
	{
		description = "aghsfort_lich_frost_shield_damage_reduction_upgrade",
		ability_name = "aghsfort_lich_frost_shield",
		special_value_name = "damage_reduction",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 5,		
	},
	{
		description = "aghsfort_lich_sinister_gaze_mana_cost_cooldown",
		ability_name = "aghsfort_lich_sinister_gaze",
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
		 description = "aghsfort_lich_sinister_gaze_radius_upgrade",
		 ability_name = "aghsfort_lich_sinister_gaze",
		 special_value_name = "aoe",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 50,
	},	
	{
		 description = "aghsfort_lich_sinister_gaze_mana_drained_upgrade",
		 ability_name = "aghsfort_lich_sinister_gaze",
		 special_value_name = "mana_drain",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 5,
	},
	{
		description = "aghsfort_lich_chain_frost_mana_cost_cooldown",
		ability_name = "aghsfort_lich_chain_frost",
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
		 description = "aghsfort_lich_chain_frost_jump_range_upgrade",
		 ability_name = "aghsfort_lich_chain_frost",
		 special_value_name = "jump_range",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 150,
	},	
	{
		 description = "aghsfort_lich_chain_frost_damage_upgrade",
		 ability_name = "aghsfort_lich_chain_frost",
		 special_value_name = "damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 150,
	},	
}
return Lich

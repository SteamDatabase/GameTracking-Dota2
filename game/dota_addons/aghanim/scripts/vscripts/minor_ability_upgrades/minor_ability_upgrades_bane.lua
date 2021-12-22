local Bane =
{

	{
		description = "aghsfort_bane_enfeeble_mana_cost_cooldown",
		ability_name = "aghsfort_bane_enfeeble",
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
		description = "aghsfort_bane_enfeeble_damage_reduction",
		ability_name = "aghsfort_bane_enfeeble",
		special_value_name = "damage_reduction",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 3,
	},

	{
		description = "aghsfort_bane_enfeeble_cast_reduction",
		ability_name = "aghsfort_bane_enfeeble",
		special_value_name = "cast_reduction",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 3,
	},

	{
		description = "aghsfort_bane_enfeeble_duration",
		ability_name = "aghsfort_bane_enfeeble",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.0,
	},
	

	{
		description = "aghsfort_bane_brain_sap_mana_cost_cooldown",
		ability_name = "aghsfort_bane_brain_sap",
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
		description = "aghsfort_bane_brain_sap_brain_sap_damage",
		ability_name = "aghsfort_bane_brain_sap",
		special_value_name = "brain_sap_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},

	{
		description = "aghsfort_bane_brain_sap_cast_range",
		ability_name = "aghsfort_bane_brain_sap",
		special_value_name = "cast_range",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 175,
	},

	{
		description = "aghsfort_bane_nightmare_mana_cost_cooldown",
		ability_name = "aghsfort_bane_nightmare",
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
		description = "aghsfort_bane_nightmare_duration",
		ability_name = "aghsfort_bane_nightmare",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.0,
	},

	{
		description = "aghsfort_bane_nightmare_nightmare_invuln_time",
		ability_name = "aghsfort_bane_nightmare",
		special_value_name = "nightmare_invuln_time",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.5,
	},

	{
		description = "aghsfort_bane_nightmare_nightmare_tick_damage",
		ability_name = "aghsfort_bane_nightmare",
		special_value_name = "nightmare_tick_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 20,
	},

	{
		description = "aghsfort_bane_fiends_grip_mana_cost_cooldown",
		ability_name = "aghsfort_bane_fiends_grip",
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
		description = "aghsfort_bane_fiends_grip_fiend_grip_damage",
		ability_name = "aghsfort_bane_fiends_grip",
		special_value_name = "fiend_grip_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},

	{
		description = "aghsfort_bane_fiends_grip_fiend_grip_mana_drain",
		ability_name = "aghsfort_bane_fiends_grip",
		special_value_name = "fiend_grip_mana_drain",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 3,
	},

	{
		description = "aghsfort_bane_fiends_grip_channel_time",
		ability_name = "aghsfort_bane_fiends_grip",
		special_value_name = "channel_time",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.0,
	},

	
}

return Bane

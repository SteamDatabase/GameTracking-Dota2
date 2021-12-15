local Mars =
{

	{
		description = "aghsfort_mars_spear_cooldown_manacost",
		ability_name = "aghsfort_mars_spear",
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
		 description = "aghsfort_mars_spear_flat_damage",
		 ability_name = "aghsfort_mars_spear",
		 special_value_name = "damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 100,
	},

	{
		 description = "aghsfort_mars_spear_flat_stun_duration",
		 ability_name = "aghsfort_mars_spear",
		 special_value_name = "stun_duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 0.75,
	},

	{
		description = "aghsfort_mars_gods_rebuke_cooldown_manacost",
		ability_name = "aghsfort_mars_gods_rebuke",
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
		 description = "aghsfort_mars_gods_rebuke_flat_crit_mult",
		 ability_name = "aghsfort_mars_gods_rebuke",
		 special_value_name = "crit_mult",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 40,
	},

	{
		 description = "aghsfort_mars_gods_rebuke_radius",
		 ability_name = "aghsfort_mars_gods_rebuke",
		 special_value_name = "radius",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 75,
	},

	{
		 description = "aghsfort_mars_gods_rebuke_flat_knockback_slow_duration",
		 ability_name = "aghsfort_mars_gods_rebuke",
		 special_value_name = "knockback_slow_duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 3.0,
	},

	{
		description = "aghsfort_mars_bulwark_cooldown_manacost",
		ability_name = "aghsfort_mars_bulwark",
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
		description = "aghsfort_mars_bulwark_damage_reduction",
		ability_name = "aghsfort_mars_bulwark",
		special_values =
		{
			{
				special_value_name = "physical_damage_reduction",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 8,
			},
			{
				special_value_name = "physical_damage_reduction_side",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 4,
			},
		},
	},

	{
		description = "aghsfort_mars_bulwark_speed_penalty",
		ability_name = "aghsfort_mars_bulwark",
		special_value_name = "redirect_speed_penatly",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = -10,
	},

	{
		description = "aghsfort_mars_bulwark_active_bulwark_block_bonus",
		ability_name = "aghsfort_mars_bulwark",
		special_value_name = "active_bulwark_block_bonus",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 12,
	},

	{
		description = "aghsfort_mars_bulwark_active_duration",
		ability_name = "aghsfort_mars_bulwark",
		special_value_name = "active_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.0,
	},

	{
		description = "aghsfort_mars_arena_of_blood_duration",
		ability_name = "aghsfort_mars_arena_of_blood",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 2.0,
	},

	{
		description = "aghsfort_mars_arena_of_blood_spear_damage",
		ability_name = "aghsfort_mars_arena_of_blood",
		special_value_name = "spear_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 90,
	},

	{
		description = "aghsfort_mars_arena_of_blood_cooldown_manacost",
		ability_name = "aghsfort_mars_arena_of_blood",
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

return Mars

local Clinkz =
{
	--------------------------------------------------------------------------------
	-- Burning Barrage
	--------------------------------------------------------------------------------

	{
		description = "aghsfort_clinkz_burning_barrage_mana_cost_cooldown",
		ability_name = "aghsfort_clinkz_burning_barrage",
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
		description = "aghsfort_clinkz_burning_barrage_wave_count",
		ability_name = "aghsfort_clinkz_burning_barrage",
		special_value_name = "wave_count",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},

	{
		description = "aghsfort_clinkz_burning_barrage_range",
		ability_name = "aghsfort_clinkz_burning_barrage",
		special_value_name = "range",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 125,
	},

	{
		description = "aghsfort_clinkz_burning_barrage_damage_pct",
		ability_name = "aghsfort_clinkz_burning_barrage",
		special_value_name = "damage_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 7,
	},

	--------------------------------------------------------------------------------
	-- Searing Arrows
	--------------------------------------------------------------------------------
	--[[
	projectile speed?
	]]

	{
		description = "aghsfort_clinkz_searing_arrows_mana_cost",
		ability_name = "aghsfort_clinkz_searing_arrows",
		special_values =
		{
			{
				special_value_name = "mana_cost",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = 10, --MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
		},
	},

	{
		description = "aghsfort_clinkz_searing_arrows_damage_bonus",
		ability_name = "aghsfort_clinkz_searing_arrows",
		special_value_name = "damage_bonus",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 7,
	},

	{
		description = "aghsfort_clinkz_searing_arrows_attack_slow",
		ability_name = "aghsfort_clinkz_searing_arrows",
		special_value_name = "attack_slow",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 15,
	},

	--------------------------------------------------------------------------------
	-- Skeleton Walk
	--------------------------------------------------------------------------------
	{
		description = "aghsfort_clinkz_skeleton_walk_mana_cost_cooldown",
		ability_name = "aghsfort_clinkz_skeleton_walk",
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
		description = "aghsfort_clinkz_skeleton_walk_move_speed",
		ability_name = "aghsfort_clinkz_skeleton_walk",
		special_value_name = "move_speed_bonus_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
	},

	{
		description = "aghsfort_clinkz_skeleton_walk_magic_resist",
		ability_name = "aghsfort_clinkz_skeleton_walk",
		special_value_name = "bonus_magic_resist",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 15,
	},

	--------------------------------------------------------------------------------
	-- Burning Army
	--------------------------------------------------------------------------------
	{
		description = "aghsfort_clinkz_burning_army_mana_cost_cooldown",
		ability_name = "aghsfort_clinkz_burning_army",
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
		description = "aghsfort_clinkz_burning_army_duration",
		ability_name = "aghsfort_clinkz_burning_army",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 4,
	},

	{
		description = "aghsfort_clinkz_burning_army_count",
		ability_name = "aghsfort_clinkz_burning_army",
		special_value_name = "count",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},

	{
		description = "aghsfort_clinkz_burning_army_damage_percent",
		ability_name = "aghsfort_clinkz_burning_army",
		special_value_name = "damage_percent",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 7,
	},

}

return Clinkz

local Ursa =
{
	{
		description = "aghsfort_ursa_earthshock_flat_damage",
		ability_name = "aghsfort_ursa_earthshock",
		special_value_name = "impact_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 75,
	},

	{
		description = "aghsfort_ursa_earthshock_percent_mana_cost",
		ability_name = "aghsfort_ursa_earthshock",
		special_value_name = "mana_cost",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 15,
	},

	{
		description = "aghsfort_ursa_earthshock_flat_radius",
		ability_name = "aghsfort_ursa_earthshock",
		special_value_name = "shock_radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 75,
	},

	{
		description = "aghsfort_ursa_earthshock_percent_cooldown",
		ability_name = "aghsfort_ursa_earthshock",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
	{
		description = "aghsfort_ursa_earthshock_flat_hop_distance",
		ability_name = "aghsfort_ursa_earthshock",
		special_value_name = "hop_distance",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 100,
	},
	{
		description = "aghsfort_ursa_earthshock_flat_movement_slow",
		ability_name = "aghsfort_ursa_earthshock",
		special_value_name = "movement_slow",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 15,
	},

	{
		description = "aghsfort_ursa_overpower_flat_max_attacks",
		ability_name = "aghsfort_ursa_overpower",
		special_value_name = "max_attacks",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},

	{
		description = "aghsfort_ursa_overpower_flat_attack_speed_bonus_pct",
		ability_name = "aghsfort_ursa_overpower",
		special_value_name = "attack_speed_bonus_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 75,
	},

	{
		description = "aghsfort_ursa_overpower_percent_cooldown",
		ability_name = "aghsfort_ursa_overpower",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},

	{
		description = "aghsfort_ursa_fury_swipes_flat_damage_per_stack",
		ability_name = "aghsfort_ursa_fury_swipes",
		special_value_name = "damage_per_stack",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 5,
	},

	{
		description = "aghsfort_ursa_fury_swipes_flat_max_swipe_stack",
		ability_name = "aghsfort_ursa_fury_swipes",
		special_value_name = "max_swipe_stack",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},

	{
		description = "aghsfort_ursa_enrage_flat_damage_reduction",
		ability_name = "aghsfort_ursa_enrage",
		special_value_name = "damage_reduction",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
	},

	{
		description = "aghsfort_ursa_enrage_flat_duration",
		ability_name = "aghsfort_ursa_enrage",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.0,
	},

	{
		description = "aghsfort_ursa_enrage_flat_status_resistance",
		ability_name = "aghsfort_ursa_enrage",
		special_value_name = "status_resistance",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10
	},

	{
		description = "aghsfort_ursa_enrage_percent_cooldown",
		ability_name = "aghsfort_ursa_enrage",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
}

return Ursa

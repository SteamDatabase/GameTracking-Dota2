local Snapfire =
{
	{
		 description = "aghsfort_snapfire_scatterblast_pct_mana_cost",
		 ability_name = "aghsfort_snapfire_scatterblast",
		 special_value_name = "mana_cost",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 15,
	},

	{
		 description = "aghsfort_snapfire_scatterblast_pct_cooldown",
		 ability_name = "aghsfort_snapfire_scatterblast",
		 special_value_name = "cooldown",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 12,
	},

	{
		 description = "aghsfort_snapfire_scatterblast_flat_damage",
		 ability_name = "aghsfort_snapfire_scatterblast",
		 special_value_name = "damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 80,
	},

	{
		 description = "aghsfort_snapfire_scatterblast_flat_debuff_duration",
		 ability_name = "aghsfort_snapfire_scatterblast",
		 special_value_name = "debuff_duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1.5,
	},

	{
		 description = "aghsfort_snapfire_scatterblast_flat_point_blank_dmg_bonus_pct",
		 ability_name = "aghsfort_snapfire_scatterblast",
		 special_value_name = "point_blank_dmg_bonus_pct",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 35.0,
	},

	{
		 description = "aghsfort_snapfire_firesnap_cookie_pct_cooldown",
		 ability_name = "aghsfort_snapfire_firesnap_cookie",
		 special_value_name = "cooldown",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 12,
	},

	{
		 description = "aghsfort_snapfire_firesnap_cookie_flat_jump_horizontal_distance",
		 ability_name = "aghsfort_snapfire_firesnap_cookie",
		 special_value_name = "jump_horizontal_distance",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 150,
	},

	{
		 description = "aghsfort_snapfire_firesnap_cookie_flat_impact_damage",
		 ability_name = "aghsfort_snapfire_firesnap_cookie",
		 special_value_name = "impact_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 100,
	},

	{
		 description = "aghsfort_snapfire_firesnap_cookie_flat_stun_duration",
		 ability_name = "aghsfort_snapfire_firesnap_cookie",
		 special_value_name = "impact_stun_duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1.0,
	},

	{
		 description = "aghsfort_snapfire_firesnap_cookie_flat_impact_radius",
		 ability_name = "aghsfort_snapfire_firesnap_cookie",
		 special_value_name = "impact_radius",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 75,
	},

	{
		 description = "aghsfort_snapfire_lil_shredder_pct_cooldown",
		 ability_name = "aghsfort_snapfire_lil_shredder",
		 special_value_name = "cooldown",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 12,
	},

	{
		 description = "aghsfort_snapfire_lil_shredder_flat_damage",
		 ability_name = "aghsfort_snapfire_lil_shredder",
		 special_value_name = "damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 20,
	},

	{
		 description = "aghsfort_snapfire_lil_shredder_flat_attacks",
		 ability_name = "aghsfort_snapfire_lil_shredder",
		 special_value_name = "buffed_attacks",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 2,
	},

	{
		 description = "aghsfort_snapfire_lil_shredder_flat_attack_range_bonus",
		 ability_name = "aghsfort_snapfire_lil_shredder",
		 special_value_name = "attack_range_bonus",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 100,
	},

	{
		 description = "aghsfort_snapfire_lil_shredder_flat_attack_speed_bonus",
		 ability_name = "aghsfort_snapfire_lil_shredder",
		 special_value_name = "attack_speed_bonus",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 150,
	},

	{
		 description = "aghsfort_snapfire_mortimer_kisses_pct_cooldown",
		 ability_name = "aghsfort_snapfire_mortimer_kisses",
		 special_value_name = "cooldown",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 12,
	},

	{
		 description = "aghsfort_snapfire_mortimer_kisses_flat_projectile_count",
		 ability_name = "aghsfort_snapfire_mortimer_kisses",
		 special_value_name = "projectile_count",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 2,
	},

	{
		 description = "aghsfort_snapfire_mortimer_kisses_flat_burn_damage",
		 ability_name = "aghsfort_snapfire_mortimer_kisses",
		 special_value_name = "burn_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 35,
	},

	{
		 description = "aghsfort_snapfire_mortimer_kisses_flat_move_slow_pct",
		 ability_name = "aghsfort_snapfire_mortimer_kisses",
		 special_value_name = "move_slow_pct",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 15,
	},

	{
		 description = "aghsfort_snapfire_mortimer_kisses_flat_damage_per_impact",
		 ability_name = "aghsfort_snapfire_mortimer_kisses",
		 special_value_name = "damage_per_impact",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 80,
	},
}

return Snapfire
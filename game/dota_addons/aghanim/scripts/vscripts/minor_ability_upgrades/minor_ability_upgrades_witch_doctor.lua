local Witch_Doctor =
{
	{
		 description = "aghsfort_witch_doctor_paralyzing_cask_manacost",
		 ability_name = "aghsfort_witch_doctor_paralyzing_cask",
		 special_value_name = "mana_cost",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 15,
	},

	{
		 description = "aghsfort_witch_doctor_voodoo_restoration_manacost",
		 ability_name = "aghsfort_witch_doctor_voodoo_restoration",
		 special_value_name = "mana_per_second",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 15,
	},

	{
		 description = "aghsfort_witch_doctor_maledict_manacost",
		 ability_name = "aghsfort_witch_doctor_maledict",
		 special_value_name = "mana_cost",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 15,
	},
	{
		 description = "aghsfort_witch_doctor_death_ward_manacost",
		 ability_name = "aghsfort_witch_doctor_death_ward",
		 special_value_name = "mana_cost",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 15,
	},	
	{
		 description = "aghsfort_witch_doctor_paralyzing_cask_cooldown",
		 ability_name = "aghsfort_witch_doctor_paralyzing_cask",
		 special_value_name = "cooldown",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 12,
	},

	{
		 description = "aghsfort_witch_doctor_maledict_cooldown",
		 ability_name = "aghsfort_witch_doctor_maledict",
		 special_value_name = "cooldown",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 12,
	},

	{
		 description = "aghsfort_witch_doctor_death_ward_cooldown",
		 ability_name = "aghsfort_witch_doctor_death_ward",
		 special_value_name = "cooldown",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 12,
	},	

	{
		 description = "aghsfort_witch_doctor_paralyzing_cask_flat_damage",
		 ability_name = "aghsfort_witch_doctor_paralyzing_cask",
		 special_value_name = "damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 25,
	},
	{
		 description = "aghsfort_witch_doctor_paralyzing_cask_flat_bounce_range",
		 ability_name = "aghsfort_witch_doctor_paralyzing_cask",
		 special_value_name = "bounce_range",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 200,
	},
	{
		 description = "aghsfort_witch_doctor_paralyzing_cask_flat_bounces",
		 ability_name = "aghsfort_witch_doctor_paralyzing_cask",
		 special_value_name = "bounces",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
	},
	{
		 description = "aghsfort_witch_doctor_paralyzing_cask_flat_stun_duration",
		 ability_name = "aghsfort_witch_doctor_paralyzing_cask",
		 special_value_name = "stun_duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 0.75,
	},
	{
		 description = "aghsfort_witch_doctor_voodoo_restoration_flat_radius",
		 ability_name = "aghsfort_witch_doctor_voodoo_restoration",
		 special_value_name = "radius",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 100,
	},
	{
		 description = "aghsfort_witch_doctor_voodoo_restoration_flat_heal",
		 ability_name = "aghsfort_witch_doctor_voodoo_restoration",
		 special_value_name = "heal",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 8,
	},
	--{
	--	description = "aghsfort_witch_doctor_voodoo_restoration_mul_heal_interval",
	--	ability_name = "aghsfort_witch_doctor_voodoo_restoration",
	--	special_value_name = "heal_interval",
	--	operator = MINOR_ABILITY_UPGRADE_OP_MUL,
	--	value = -15,
	--},

	{
		 description = "aghsfort_witch_doctor_maledict_flat_radius",
		 ability_name = "aghsfort_witch_doctor_maledict",
		 special_value_name = "radius",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 40,
	},
	{
		 description = "aghsfort_witch_doctor_maledict_flat_bonus_damage",
		 ability_name = "aghsfort_witch_doctor_maledict",
		 special_value_name = "bonus_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 16,
	},
	{
		 description = "aghsfort_witch_doctor_maledict_flat_max_bonus_damage",
		 ability_name = "aghsfort_witch_doctor_maledict",
		 special_value_name = "max_bonus_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 50,
	},	
	{
		 description = "aghsfort_witch_doctor_maledict_flat_ticks",
		 ability_name = "aghsfort_witch_doctor_maledict",
		 special_value_name = "ticks",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
	},
	{
		 description = "aghsfort_witch_doctor_death_ward_flat_damage",
		 ability_name = "aghsfort_witch_doctor_death_ward",
		 special_value_name = "damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 50,
	},
	{
		 description = "aghsfort_witch_doctor_death_ward_flat_bounce_radius",
		 ability_name = "aghsfort_witch_doctor_death_ward",
		 special_value_name = "bounce_radius",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 150,
	},
	{
		 description = "aghsfort_witch_doctor_death_ward_flat_bounces",
		 ability_name = "aghsfort_witch_doctor_death_ward",
		 special_value_name = "bounces",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
	},
	{
		 description = "aghsfort_witch_doctor_death_ward_flat_channel_duration",
		 ability_name = "aghsfort_witch_doctor_death_ward",
		 special_value_name = "channel_duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
	},		

}

return Witch_Doctor
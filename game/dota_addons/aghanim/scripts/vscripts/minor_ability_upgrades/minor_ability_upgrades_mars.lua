local Mars =
{
	-- {
	-- 	 description = "aghsfort_mars_spear_percent_manacost",
	-- 	 ability_name = "aghsfort_mars_spear",
	-- 	 special_value_name = "mana_cost",
	-- 	 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
	-- 	 value = 15,
	-- },

	{
		 description = "aghsfort_mars_spear_percent_cooldown",
		 ability_name = "aghsfort_mars_spear",
		 special_value_name = "cooldown",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 12,
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
		 value = 0.5,
	},


	-- {
	-- 	 description = "aghsfort_mars_gods_rebuke_percent_manacost",
	-- 	 ability_name = "aghsfort_mars_gods_rebuke",
	-- 	 special_value_name = "mana_cost",
	-- 	 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
	-- 	 value = 15,
	-- },

	{
		 description = "aghsfort_mars_gods_rebuke_percent_cooldown",
		 ability_name = "aghsfort_mars_gods_rebuke",
		 special_value_name = "cooldown",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 12,
	},


	{
		 description = "aghsfort_mars_gods_rebuke_flat_crit_mult",
		 ability_name = "aghsfort_mars_gods_rebuke",
		 special_value_name = "crit_mult",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 30,
	},

	{
		 description = "aghsfort_mars_gods_rebuke_flat_knockback_slow_duration",
		 ability_name = "aghsfort_mars_gods_rebuke",
		 special_value_name = "knockback_slow_duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 3.0,
	},

	{
		description = "aghsfort_mars_bulwark_damage_reduction_front",
		ability_name = "aghsfort_mars_bulwark",
		special_value_name = "physical_damage_reduction",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
	},

	-- {
	-- 	description = "aghsfort_mars_bulwark_damage_reduction_sides",
	-- 	ability_name = "aghsfort_mars_bulwark",
	-- 	special_value_name = "physical_damage_reduction_side",
	-- 	operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	-- 	value = 10,
	-- },
	{
		 description = "aghsfort_mars_bulwark_percent_cooldown",
		 ability_name = "aghsfort_mars_bulwark",
		 special_value_name = "cooldown",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 12,
	},	
	{
		description = "aghsfort_mars_bulwark_active_bulwark_block_bonus",
		ability_name = "aghsfort_mars_bulwark",
		special_value_name = "active_bulwark_block_bonus",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
	},

	{
		description = "aghsfort_mars_bulwark_active_duration",
		ability_name = "aghsfort_mars_bulwark",
		special_value_name = "active_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.0,
	},

	-- {
	-- 	 description = "aghsfort_mars_arena_of_blood_manacost",
	-- 	 ability_name = "aghsfort_mars_arena_of_blood",
	-- 	 special_value_name = "mana_cost",
	-- 	 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
	-- 	 value = 15,
	-- },

	{
		 description = "aghsfort_mars_arena_of_blood_cooldown",
		 ability_name = "aghsfort_mars_arena_of_blood",
		 special_value_name = "cooldown",
		 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		 value = 12,
	},
	{
		description = "aghsfort_mars_arena_of_blood_duration",
		ability_name = "aghsfort_mars_arena_of_blood",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},

	{
		description = "aghsfort_mars_arena_of_blood_spear_damage",
		ability_name = "aghsfort_mars_arena_of_blood",
		special_value_name = "spear_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 65,
	},

	--{
	--	description = "aghsfort_mars_arena_of_blood_spear_attack_interval",
	--	ability_name = "aghsfort_mars_arena_of_blood",
	--	special_value_name = "spear_attack_interval",
	--	 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
	--	 value = -30,
	--},

}

return Mars
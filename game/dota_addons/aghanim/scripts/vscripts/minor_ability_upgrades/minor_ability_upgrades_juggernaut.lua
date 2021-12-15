local Juggernaut =
{
	{
		 description = "aghsfort_juggernaut_blade_fury_radius",
		 ability_name = "aghsfort_juggernaut_blade_fury",
		 special_value_name = "blade_fury_radius",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 25,
	},
	{
		 description = "aghsfort_juggernaut_blade_fury_damage",
		 ability_name = "aghsfort_juggernaut_blade_fury",
		 special_value_name = "blade_fury_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 25,
	},
	{
		 description = "aghsfort_juggernaut_blade_fury_duration",
		 ability_name = "aghsfort_juggernaut_blade_fury",
		 special_value_name = "duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
	},
	{
		 description = "aghsfort_juggernaut_blade_fury_mana_cost_cooldown",
		 ability_name = "aghsfort_juggernaut_blade_fury",
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
		 description = "aghsfort_juggernaut_healing_ward_heal_amount",
		 ability_name = "aghsfort_juggernaut_healing_ward",
		 special_value_name = "healing_ward_heal_amount",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 0.5,
	},
	{
		 description = "aghsfort_juggernaut_healing_ward_aura_radius",
		 ability_name = "aghsfort_juggernaut_healing_ward",
		 special_value_name = "healing_ward_aura_radius",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 50,
	},
	{
		 description = "aghsfort_juggernaut_healing_ward_pulse_count",
		 ability_name = "aghsfort_juggernaut_healing_ward",
		 special_value_name = "healing_ward_pulse_count",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
	},
	{
		 description = "aghsfort_juggernaut_healing_ward_mana_cost_cooldown",
		 ability_name = "aghsfort_juggernaut_healing_ward",
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
		 description = "aghsfort_juggernaut_blade_dance_crit_chance",
		 ability_name = "aghsfort_juggernaut_blade_dance",
		 special_value_name = "blade_dance_crit_chance",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 3,
	},
	{
		 description = "aghsfort_juggernaut_blade_dance_crit_mult",
		 ability_name = "aghsfort_juggernaut_blade_dance",
		 special_value_name = "blade_dance_crit_mult",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 25,
	},



	{
		 description = "aghsfort_juggernaut_omni_slash_bonus_attack_speed",
		 ability_name = "aghsfort_juggernaut_omni_slash",
		 special_value_name = "bonus_attack_speed",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 40,
	},
	{
		 description = "aghsfort_juggernaut_omni_slash_duration",
		 ability_name = "aghsfort_juggernaut_omni_slash",
		 special_value_name = "duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = .5,
	},
	{
		 description = "aghsfort_juggernaut_omni_slash_mana_cost_cooldown",
		 ability_name = "aghsfort_juggernaut_omni_slash",
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

return Juggernaut

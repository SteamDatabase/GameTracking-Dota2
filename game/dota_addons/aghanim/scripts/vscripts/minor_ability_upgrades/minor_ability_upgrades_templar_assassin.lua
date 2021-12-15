local Templar_Assassin =
{

	{
		description = "aghsfort_templar_assassin_refraction_mana_cost_cooldown",
		ability_name = "aghsfort_templar_assassin_refraction",
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
		 description = "aghsfort_templar_assassin_refraction_instances",
		 ability_name = "aghsfort_templar_assassin_refraction",
		 special_value_name = "instances",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
	},
	
	{
		 description = "aghsfort_templar_assassin_refraction_bonus_damage",
		 ability_name = "aghsfort_templar_assassin_refraction",
		 special_value_name = "bonus_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 25,
	},
	{
		 description = "aghsfort_templar_assassin_refraction_max_damage_absorb",
		 ability_name = "aghsfort_templar_assassin_refraction",
		 special_value_name = "max_damage_absorb",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 50,
	},

	{
		 description = "aghsfort_templar_assassin_meld_bonus_damage",
		 ability_name = "aghsfort_templar_assassin_meld",
		 special_value_name = "bonus_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 50,
	},
	{
		 description = "aghsfort_templar_assassin_meld_bonus_armor",
		 ability_name = "aghsfort_templar_assassin_meld",
		 special_value_name = "bonus_armor",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = -1,
	},

	{
		 description = "aghsfort_templar_assassin_psi_blades_bonus_attack_range",
		 ability_name = "aghsfort_templar_assassin_psi_blades",
		 special_value_name = "bonus_attack_range",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 30,
	},
	{
		 description = "aghsfort_templar_assassin_psi_blades_attack_spill_range",
		 ability_name = "aghsfort_templar_assassin_psi_blades",
		 special_value_name = "attack_spill_range",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 0.25,
	},
	{
		 description = "aghsfort_templar_assassin_psi_blades_attack_spill_width",
		 ability_name = "aghsfort_templar_assassin_psi_blades",
		 special_value_name = "attack_spill_width",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 30,
	},


	{
		 description = "aghsfort_templar_assassin_psionic_trap_max_traps",
		 ability_name = "aghsfort_templar_assassin_psionic_trap",
		 special_value_name = "max_traps",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
	},
	{
		 description = "aghsfort_templar_assassin_psionic_trap_trap_radius",
		 ability_name = "aghsfort_templar_assassin_psionic_trap",
		 special_value_name = "trap_radius",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 50,
	},	

	{
		 description = "aghsfort_templar_assassin_psionic_trap_trap_damage",
		 ability_name = "aghsfort_templar_assassin_psionic_trap",
		 special_value_name = "trap_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 100,
	},	

	{
		description = "aghsfort_templar_assassin_psionic_trap_mana_cost_cooldown",
		ability_name = "aghsfort_templar_assassin_psionic_trap",
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

return Templar_Assassin
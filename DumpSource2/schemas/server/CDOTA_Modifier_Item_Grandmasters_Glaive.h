class CDOTA_Modifier_Item_Grandmasters_Glaive : public CDOTA_Buff_Item
{
	int32 sange_bonus_strength;
	int32 sange_status_resistance;
	int32 sange_hp_regen_amp;
	int32 kaya_bonus_intellect;
	int32 kaya_spell_amp;
	int32 kaya_mana_regen_multiplier;
	int32 kaya_magic_damage_attack;
	int32 yasha_bonus_agility;
	int32 yasha_bonus_attack_speed;
	int32 yasha_movement_speed_percent_bonus;
	int32 m_iCurrentStance;
	int32 bonus_strength;
	int32 bash_chance_melee;
	int32 bash_chance_ranged;
	float32 bash_duration;
	float32 bash_cooldown;
	int32 bonus_chance_damage;
	int32 bonus_damage;
	CUtlVector< int16 > m_InFlightAttackRecords;
};

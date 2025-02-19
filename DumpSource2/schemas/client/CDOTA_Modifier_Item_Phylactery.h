class CDOTA_Modifier_Item_Phylactery
{
	int32 bonus_health;
	int32 bonus_mana;
	float32 bonus_mana_regen;
	float32 bonus_spell_damage;
	float32 slow_duration;
	int32 bonus_all_stats;
	float32 bonus_per_kill;
	float32 max_kill_bonus;
	float32 kill_bonus_window;
	CUtlVector< C_DOTABaseAbility* > vecActivatedAbilities;
};

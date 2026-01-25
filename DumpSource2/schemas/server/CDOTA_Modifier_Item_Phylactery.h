class CDOTA_Modifier_Item_Phylactery : public CDOTA_Buff_Item
{
	int32 bonus_all_stats;
	float32 bonus_health_regen;
	float32 bonus_mana_regen;
	float32 bonus_spell_damage;
	float32 slow_duration;
	float32 bonus_per_kill;
	float32 max_kill_bonus;
	float32 kill_bonus_window;
	CUtlVector< CDOTABaseAbility* > vecActivatedAbilities;
};

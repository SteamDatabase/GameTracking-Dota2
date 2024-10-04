class CDOTA_Modifier_Item_Angels_Demise : public CDOTA_Buff_Item
{
	int32 bonus_health;
	int32 bonus_mana;
	float32 bonus_mana_regen;
	int32 bonus_spell_damage;
	float32 slow_duration;
	int32 bonus_all_stats;
	int32 bonus_damage;
	int32 crit_chance;
	int32 crit_multiplier;
	int32 spell_crit_multiplier;
	int32 spell_crit_flat;
	CUtlVector< CDOTABaseAbility* > vecActivatedAbilities;
}

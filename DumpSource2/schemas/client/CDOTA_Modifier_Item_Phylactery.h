class CDOTA_Modifier_Item_Phylactery : public CDOTA_Buff_Item
{
	int32 bonus_health;
	int32 bonus_mana;
	float32 bonus_mana_regen;
	int32 bonus_spell_damage;
	float32 slow_duration;
	int32 bonus_all_stats;
	CUtlVector< C_DOTABaseAbility* > vecActivatedAbilities;
};

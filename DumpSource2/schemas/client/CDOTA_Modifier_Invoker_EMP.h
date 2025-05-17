class CDOTA_Modifier_Invoker_EMP : public CDOTA_Buff
{
	int32 area_of_effect;
	int32 mana_burned;
	float32 damage_per_mana;
	float32 spell_lifesteal;
	float32 spell_amp;
	int32 self_mana_restore_pct;
	CHandle< C_BaseEntity > m_hPullThinker;
};

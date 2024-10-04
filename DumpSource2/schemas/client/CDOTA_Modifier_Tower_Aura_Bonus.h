class CDOTA_Modifier_Tower_Aura_Bonus : public CDOTA_Buff
{
	int32 bonus_armor;
	float32 hp_regen;
	bool m_bOverrideArmor;
	bool m_bOverrideRegen;
	bool m_bSentFirstRefresh;
}

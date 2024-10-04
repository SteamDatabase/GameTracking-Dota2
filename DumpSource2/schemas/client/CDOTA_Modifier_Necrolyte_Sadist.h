class CDOTA_Modifier_Necrolyte_Sadist : public CDOTA_Buff
{
	float32 aura_radius;
	bool m_bStackCountChanged;
	CUtlVector< GameTime_t > m_fStackExpireTimes;
	float32 bonus_aoe;
	float32 bonus_spell_amp;
}

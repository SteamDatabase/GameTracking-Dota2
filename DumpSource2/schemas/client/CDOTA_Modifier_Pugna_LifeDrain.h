class CDOTA_Modifier_Pugna_LifeDrain
{
	int32 health_drain;
	int32 ally_healing;
	float32 health_drain_death_boost;
	float32 tick_rate;
	bool m_bDoRangeCheck;
	ParticleIndex_t m_nFXIndex;
	GameTime_t m_flElapsedTime;
	bool m_bPrimary;
	bool m_bShard;
	bool m_bFromWard;
	CHandle< C_BaseEntity > m_hWard;
	float32 spell_amp_drain_duration;
	int32 max_spell_amp_drain_pct;
	int32 spell_amp_drain_rate;
	int32 spell_amp_drain_rate_ward;
	int32 spell_amp_drain_max;
	int32 health_to_mana_rate;
};

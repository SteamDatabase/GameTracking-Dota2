class CDOTA_Modifier_Grimstroke_SoulChain : public CDOTA_Buff
{
	CHandle< C_BaseEntity > m_hPartner;
	bool m_bIsPrimary;
	bool m_bEscaped;
	bool m_bTethered;
	ParticleIndex_t m_nFXIndex;
	ParticleIndex_t m_nFXIndexA;
	ParticleIndex_t m_nFXIndexB;
	bool m_bStartedLeashSound;
	float32 m_fLeashDistance;
	GameTime_t m_fOriginalStartTime;
	ParticleIndex_t m_nOverheadFXIndex;
	int32 chain_latch_radius;
	int32 chain_break_distance;
	float32 leash_limit_multiplier;
	float32 chain_duration;
	float32 creep_duration_pct;
	int32 bonus_reflected_spell_damage;
}

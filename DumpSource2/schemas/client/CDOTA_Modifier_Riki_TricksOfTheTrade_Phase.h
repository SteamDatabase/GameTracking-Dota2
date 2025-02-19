class CDOTA_Modifier_Riki_TricksOfTheTrade_Phase
{
	ParticleIndex_t m_nFxIndex;
	CHandle< C_BaseEntity > m_hTarget;
	CountdownTimer m_Timer;
	CHandle< C_BaseEntity > m_hPreviousTarget;
	int32 m_nSucceessiveHits;
	int32 damage_pct;
	int32 agility_pct;
	float32 creep_agility_multiplier;
	float32 m_flMultiplier;
	float32 cooldown_reduction_per_creep_kill;
};

class CDOTA_Modifier_Riki_TricksOfTheTrade_Phase : public CDOTA_Buff
{
	ParticleIndex_t m_nFxIndex;
	CHandle< CBaseEntity > m_hTarget;
	CountdownTimer m_Timer;
	CHandle< CBaseEntity > m_hPreviousTarget;
	int32 m_nSucceessiveHits;
	bool m_bGrantedGem;
	float32 attack_rate;
	int32 damage_pct;
	int32 agility_pct;
	float32 creep_agility_multiplier;
	float32 m_flMultiplier;
}

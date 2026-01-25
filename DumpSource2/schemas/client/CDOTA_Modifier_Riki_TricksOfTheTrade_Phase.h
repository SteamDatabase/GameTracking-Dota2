class CDOTA_Modifier_Riki_TricksOfTheTrade_Phase : public CDOTA_Buff
{
	ParticleIndex_t m_nFxIndex;
	CHandle< C_BaseEntity > m_hTarget;
	CountdownTimer m_Timer;
	CHandle< C_BaseEntity > m_hPreviousTarget;
	int32 m_nSucceessiveHits;
	float32 attack_damage;
	int32 agility_pct;
	float32 cooldown_reduction_per_creep_kill;
	float32 speed_per_attack;
	float32 radius;
	int32 interval_targets;
	bool pocket_riki_enabled;
	float32 base_attack_damage_pct;
};

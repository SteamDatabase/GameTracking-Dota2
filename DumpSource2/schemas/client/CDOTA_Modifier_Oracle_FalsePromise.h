class CDOTA_Modifier_Oracle_FalsePromise : public CDOTA_Buff
{
	bool m_bWaitingForInvulnerability;
	bool m_bDisableHealing;
	float32 m_flHealthOnCreated;
	ParticleIndex_t m_nFXIndex;
	ParticleIndex_t m_nFXIndexB;
	float32 m_flRunningDmg;
	float32 m_flRunningHealth;
	int32 bonus_armor;
};

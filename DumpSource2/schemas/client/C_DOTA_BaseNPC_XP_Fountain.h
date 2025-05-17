class C_DOTA_BaseNPC_XP_Fountain : public C_DOTA_BaseNPC_Building
{
	ParticleIndex_t m_nFxRing;
	bool m_bActive;
	bool m_bIsBeingGranted;
	bool m_bWasBeingGranted;
	int32 m_nIntervals;
};

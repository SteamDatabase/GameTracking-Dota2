class CIngameEvent_MuertaReleaseSpring2023 : public C_IngameEvent_Base
{
	bool m_bMiniGameActive;
	int8[10] m_vecTargetAssignments;
	uint8[10] m_vecMiniGamePoints;
	uint8[10] m_vecMiniGameKills;
	CUtlVector< ParticleIndex_t > m_activeGravestones;
}

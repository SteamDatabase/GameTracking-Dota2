class CSurvivorsPowerUp_Snotty : public CSurvivorsPowerUp_AreaAttack_Circle
{
	CUtlVector< SurvivorsUnitID_t > m_vecSnotties;
	float32 m_flRotationSpeedDeg;
	float32 m_flRotationDist;
	CUtlVector< SurvivorsParticleID_t > m_vecSnottyParticles;
	float32 m_flParticleLifetime;
	float32 m_flTimeUntilNextSalvo;
	int32 m_nSalvosRemaining;
	bool m_bFirstSalvo;
};

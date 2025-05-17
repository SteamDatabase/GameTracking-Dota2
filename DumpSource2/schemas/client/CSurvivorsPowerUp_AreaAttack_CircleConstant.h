class CSurvivorsPowerUp_AreaAttack_CircleConstant : public CSurvivorsPowerUp_AreaAttack_Circle
{
	CUtlOrderedMap< SurvivorsUnitID_t, float32 > m_mapEnemyDamagedTimers;
	CNewParticleEffect* m_pParticleEffect;
	float32 m_flNextTrailCreationTimer;
};

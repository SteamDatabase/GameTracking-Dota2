class CSurvivorsEnemyDefinition_Resurrector : public CSurvivorsEnemyDefinition
{
	int32 m_nNumResurrectionTimes;
	float32 m_flMovementSpeedMultiplierPerDeath;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sResurrectParticleName;
};

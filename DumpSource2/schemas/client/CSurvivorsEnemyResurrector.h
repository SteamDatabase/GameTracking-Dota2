class CSurvivorsEnemyResurrector
{
	int32 m_nTotalResurrections;
	int32 m_nResurrectionsRemaining;
	float32 m_flMovementSpeedMultiplierPerDeath;
	bool m_bIsDyingWithResurrection;
	bool m_bIsResurrecting;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sResurrectParticleName;
};

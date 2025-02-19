class CSurvivorsEnemyAbsorber
{
	float32 m_flPercentHealthAbsorbed;
	float32 m_flBaseModelScale;
	float32 m_flModelScaleIncreasePerAbsorb;
	float32 m_flMaxModelScale;
	float32 m_flAbsorbRadius;
	float32 m_flCurrentModelScale;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sAbsorbParticleName;
};

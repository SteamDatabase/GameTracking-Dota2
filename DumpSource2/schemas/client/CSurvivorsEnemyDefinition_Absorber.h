class CSurvivorsEnemyDefinition_Absorber : public CSurvivorsEnemyDefinition
{
	float32 m_flModelScaleIncreasePerAbsorb;
	float32 m_flMaxModelScale;
	float32 m_flAbsorbRadius;
	float32 m_flPercentHealthAbsorbed;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sAbsorbParticleName;
};

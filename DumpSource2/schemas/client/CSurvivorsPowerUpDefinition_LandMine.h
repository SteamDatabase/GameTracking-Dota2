class CSurvivorsPowerUpDefinition_LandMine : public CSurvivorsPowerUpDefinition
{
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sParticle;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sExplosionParticle;
	float32 m_flScepterVacuumRadius;
	float32 m_flScepterVacuumDistance;
};

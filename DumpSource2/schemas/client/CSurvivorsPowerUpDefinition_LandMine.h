class CSurvivorsPowerUpDefinition_LandMine : public CSurvivorsPowerUpDefinition
{
	float32 m_flScepterVacuumRadius;
	float32 m_flScepterVacuumDistance;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sParticle;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sExplosionParticle;
};

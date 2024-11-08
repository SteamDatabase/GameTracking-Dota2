class CSurvivorsPowerUp_LandMine : public CSurvivorsPowerUp
{
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sParticle;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sExplosionParticle;
	float32 m_flScepterVacuumRadius;
	float32 m_flScepterVacuumDistance;
};

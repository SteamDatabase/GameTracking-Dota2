class CSurvivorsPowerUp_Spirits : public CSurvivorsPowerUp
{
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sParticle;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sExplosionParticle;
	bool m_bActive;
	float32 m_flDurationTimer;
	float32 m_flRange;
};

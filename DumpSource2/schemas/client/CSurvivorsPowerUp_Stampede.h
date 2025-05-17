class CSurvivorsPowerUp_Stampede : public CSurvivorsPowerUp
{
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sParticle;
	SurvivorsParticleID_t m_unParticleID;
	CNewParticleEffect* m_pParticle;
};

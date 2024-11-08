class CSurvivorsPowerUp_InstantAttack : public CSurvivorsPowerUp
{
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sParticle;
	ESurvivorsAttackTargeting m_eTargeting;
};

class CSurvivorsPowerUpDefinition_InstantAttack : public CSurvivorsPowerUpDefinition
{
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sParticle;
	ESurvivorsAttackTargeting m_eTargeting;
};

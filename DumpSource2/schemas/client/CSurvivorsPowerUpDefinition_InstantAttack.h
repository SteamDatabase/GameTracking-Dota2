class CSurvivorsPowerUpDefinition_InstantAttack : public CSurvivorsPowerUpDefinition
{
	ESurvivorsAttackTargeting m_eTargeting;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sParticle;
};

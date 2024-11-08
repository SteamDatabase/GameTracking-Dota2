class CSurvivorsPowerUpDefinition_AreaAttack : public CSurvivorsPowerUpDefinition
{
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sParticle;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sHitImpactParticle;
	ESurvivorsAreaAttackOrigin m_eOrigin;
	float32 m_flRemoveParticleTimeDelay;
};

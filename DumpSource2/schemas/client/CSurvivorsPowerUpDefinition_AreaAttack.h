class CSurvivorsPowerUpDefinition_AreaAttack : public CSurvivorsPowerUpDefinition
{
	ESurvivorsAreaAttackOrigin m_eOrigin;
	float32 m_flRemoveParticleTimeDelay;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sParticle;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sHitImpactParticle;
};

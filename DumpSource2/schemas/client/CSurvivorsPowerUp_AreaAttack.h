class CSurvivorsPowerUp_AreaAttack : public CSurvivorsPowerUp
{
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sParticle;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sHitImpactParticle;
	CUtlVector< CSurvivorsPowerUpDamageTickInfo > m_vecQueuedDamageTicks;
	ESurvivorsAreaAttackOrigin m_eOrigin;
	float32 m_flRemoveParticleTimeDelay;
	CUtlVector< CSurvivorsAttackParticleInfo > m_vecAttackParticles;
};

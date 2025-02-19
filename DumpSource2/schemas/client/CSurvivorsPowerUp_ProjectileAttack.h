class CSurvivorsPowerUp_ProjectileAttack
{
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sParticle;
	ESurvivorsAttackTargeting m_eTargeting;
	ESurvivorsAttackTargeting m_eBounceTargeting;
	float32 m_flSpawnMinimumLifetime;
	float32 m_flBounceMinimumLifetime;
	bool m_bExpireOnWorldCollision;
	bool m_bAbilityActiveWhileProjectileIsActive;
	int32 m_nActiveProjectilesToTrack;
	CUtlVector< float32 > m_vecQueuedProjectileTimers;
	CUtlVector< SurvivorsUnitID_t > m_vecTargetExclusions;
};

class CSurvivorsPowerUpDefinition_ProjectileAttack
{
	ESurvivorsAttackTargeting m_eTargeting;
	ESurvivorsAttackTargeting m_eBounceTargeting;
	float32 m_flBounceMinimumLifetime;
	float32 m_flSpawnMinimumLifetime;
	bool m_bExpireOnWorldCollision;
	bool m_bAbilityActiveWhileProjectileIsAlive;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sParticle;
};

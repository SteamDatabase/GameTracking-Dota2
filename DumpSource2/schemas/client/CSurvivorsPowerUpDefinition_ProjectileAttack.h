// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MVDataRoot
class CSurvivorsPowerUpDefinition_ProjectileAttack : public CSurvivorsPowerUpDefinition
{
	ESurvivorsAttackTargeting m_eTargeting;
	ESurvivorsAttackTargeting m_eBounceTargeting;
	float32 m_flBounceMinimumLifetime;
	float32 m_flSpawnMinimumLifetime;
	bool m_bExpireOnWorldCollision;
	bool m_bAbilityActiveWhileProjectileIsAlive;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sParticle;
};

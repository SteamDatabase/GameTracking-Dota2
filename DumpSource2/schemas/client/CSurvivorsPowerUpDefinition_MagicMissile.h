class CSurvivorsPowerUpDefinition_MagicMissile : public CSurvivorsPowerUpDefinition_ProjectileAttack
{
	float32 m_flShardDamageMultiplier;
	float32 m_flScepterDamageIncreasePerEnemyKilled;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sImpactParticle;
};

class CSurvivorsPowerUp_MagicMissile : public CSurvivorsPowerUp_ProjectileAttack
{
	int32 m_nEnemiesKilled;
	float32 m_flShardDamageMultiplier;
	float32 m_flScepterDamageIncreasePerEnemyKilled;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sPhysicalWeaknessEffect;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sImpactParticle;
};

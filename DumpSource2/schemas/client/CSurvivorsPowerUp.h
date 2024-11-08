class CSurvivorsPowerUp
{
	SurvivorsPowerUpID_t m_unPowerUpID;
	int32 m_nLevel;
	int32 m_nMaxLevel;
	int32 m_nNumAuthoredLevels;
	CUtlVector< CSurvivorsUpgradeDefinition > m_vecMinorUpgrades;
	bool m_bHasShardUpgrade;
	bool m_bHasScepterUpgrade;
	float32 m_flElapsedTime;
	float32 m_flTimeUntilNextTrigger;
	bool m_bHasTriggered;
	bool m_bIsPassive;
	bool m_bIsProjectile;
	bool m_bIsInnate;
	bool m_bModifierParticleUsesOverheadOffset;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sModifierParticle;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sStunParticle;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sVulnerableParticle;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sFreezeParticle;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sHitStatusEffectParticle;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sWarmupEffectParticle;
	float32 m_flWarmupEffectTime;
	float32 m_flSpawnPickupOnKillPercent;
	SurvivorsPickupID_t m_unSpawnPickupOnKillID;
};

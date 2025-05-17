// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MVDataRoot
class CSurvivorsEnemyDefinition_ImperiaBoss : public CSurvivorsEnemyDefinition
{
	float32 m_flBurningGroundImpactDamage;
	float32 m_flBurningGroundImpactRadius;
	float32 m_flBurningGroundImpactSpawnDelay;
	float32 m_flBurningGroundFlamesDuration;
	float32 m_flBurningGroundDoTDuration;
	float32 m_flBurningGroundDoTDamage;
	float32 m_flBurningGroundImpactStunDuration;
	int32 m_nBurningGroundInstancesPerEnrageLevel;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sBurningGroundImpactParticleName;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sBurningGroundDoTParticleName;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sBurningGroundBurnParticleName;
	float32 m_flRadiateRaysCastStartDuration;
	float32 m_flRadiateRaysDuration;
	float32 m_flRadiateRaysInterval;
	float32 m_flRadiateRaysAngle;
	float32 m_flRadiateRaysSpeed;
	float32 m_flRadiateRaysDamage;
	float32 m_flRadiateRaysProjectileRadius;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sRadiateRaysRayParticle;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sRadiateRaysBuffParticle;
	float32 m_nDemonPortalsNumToCreate;
	float32 m_flDemonPortalDeactivateTime;
	int32 m_nMaxDemonPortalCount;
	float32 m_flDemonPortalDeactivateRadius;
	CUtlVector< CUtlString > m_vecDemonPortalSpawners;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sDemonPortalsPortalParticle;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sDemonPortalsTelegraphParticle;
	int32 m_nNumMagicMissiles;
	float32 m_flMagicMissileProjectileSpeed;
	float32 m_flMagicMissileProjectileSpeedIncreasePerEnrage;
	float32 m_flMagicMissileDamage;
	float32 m_flMagicMissileProjectileRadius;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sMagicMissileParticle;
	float32 m_flInitialEnrageTime;
	float32 m_flIncrementalEnrageTime;
	CUtlVector< float32 > m_vecMandatoryEnrageHealthThresholds;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sImperiaAmbientBody;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sImperiaAmbientWings;
};

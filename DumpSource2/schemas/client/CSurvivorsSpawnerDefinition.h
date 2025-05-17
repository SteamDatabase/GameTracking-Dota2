// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MVDataRoot
class CSurvivorsSpawnerDefinition
{
	CUtlString m_sEnemyName;
	CUtlString m_sEnemyDisplayName;
	int32 m_nMinimumEnemyCount;
	int32 m_nMaxSpawnCountPerInterval;
	int32 m_nOverflowEnemySpawnCount;
	float32 m_flSpawnInterval;
	ESurvivorsEnemySpawnBehavior m_eSpawnBehavior;
	float32 m_flFixedDirectionSpawnDistanceVariance;
	bool m_bIsPersistant;
	bool m_bResetSpawnIntervalOnKill;
	float32 m_flSpawnChance;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sSpawnParticle;
	Vector2D m_flSpawnOvalRadius;
	CUtlString m_sSpawnInfoTargetName;
	CUtlString m_sMinimapIconClass;
	float32 m_flPerpendicularWallSpacing;
	bool m_bIgnoreDifficultySpawnMultiplier;
	ESurvivorsEnemySpawnPositionsLayer m_eSpawnPositionsLayer;
};

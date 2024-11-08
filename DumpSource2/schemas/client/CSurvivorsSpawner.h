class CSurvivorsSpawner
{
	CUtlVector< SurvivorsUnitID_t > m_vecSpawnedUnitIDs;
	SurvivorsEnemyID_t m_unEnemyID;
	int32 m_nMinimumEnemyCount;
	int32 m_nMaxSpawnCountPerInterval;
	int32 m_nOverflowEnemySpawnCount;
	ESurvivorsEnemySpawnBehavior m_eSpawnBehavior;
	float32 m_flFixedDirectionSpawnDistanceVariance;
	Vector2D m_flSpawnOvalRadius;
	CUtlString m_sSpawnInfoTargetName;
	CUtlVector< int32 > m_vecOccupiedPositions;
	float32 m_flPerpendicularWallSpacing;
	Vector m_vSpawnerOrigin;
	bool m_bSpawningComplete;
	bool m_bIsPersistant;
	bool m_bResetSpawnIntervalOnKill;
	bool m_bIsActive;
	float32 m_flDuration;
	float32 m_flSpawnIntervalTimer;
	float32 m_flSpawnInterval;
	float32 m_flSpawnChance;
	ESurvivorsEnemySpawnPositionsLayer m_eSpawnPositionsLayer;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sSpawnParticle;
};

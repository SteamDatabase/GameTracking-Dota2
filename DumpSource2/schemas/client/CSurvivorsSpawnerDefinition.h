// MGetKV3ClassDefaults = {
//	"_class": "CSurvivorsSpawnerDefinition",
//	"m_sEnemyName": "",
//	"m_sEnemyDisplayName": "",
//	"m_nMinimumEnemyCount": 1,
//	"m_nMaxSpawnCountPerInterval": 30,
//	"m_nOverflowEnemySpawnCount": 0,
//	"m_flSpawnInterval": 0.000000,
//	"m_eSpawnBehavior": "FIXED_DIRECTION",
//	"m_flFixedDirectionSpawnDistanceVariance": 0.000000,
//	"m_bIsPersistant": false,
//	"m_bResetSpawnIntervalOnKill": false,
//	"m_flSpawnChance": 1.000000,
//	"m_sSpawnParticle": "",
//	"m_flSpawnOvalRadius":
//	[
//		0.000000,
//		0.000000
//	],
//	"m_sSpawnInfoTargetName": "",
//	"m_sMinimapIconClass": "",
//	"m_flPerpendicularWallSpacing": 223455947136172032.000000,
//	"m_bIgnoreDifficultySpawnMultiplier": false,
//	"m_eSpawnPositionsLayer": "ENEMY_MAIN"
//}
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

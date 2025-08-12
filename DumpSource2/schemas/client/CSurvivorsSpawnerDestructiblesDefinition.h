// MGetKV3ClassDefaults = {
//	"_class": "CSurvivorsSpawnerDestructiblesDefinition",
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
//	"m_eSpawnPositionsLayer": "ENEMY_MAIN",
//	"m_flMinimumDistanceBetween": 0.000000,
//	"m_flDestroyDistance": 0.000000
//}
// MVDataRoot
class CSurvivorsSpawnerDestructiblesDefinition : public CSurvivorsSpawnerDefinition
{
	float32 m_flMinimumDistanceBetween;
	float32 m_flDestroyDistance;
};

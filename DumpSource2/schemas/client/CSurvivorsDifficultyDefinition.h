// MGetKV3ClassDefaults = {
//	"m_sLocDifficultyName": "",
//	"m_sLocDifficultyDescription": "",
//	"m_sLocDifficultyUpgradeText": "",
//	"m_flPlayerMaxHPMultiplier": 0.000000,
//	"m_flPlayerHPRegenerationMultiplier": 0.000000,
//	"m_flEnemyHealthMultiplier": 0.000000,
//	"m_flEnemyDamageMultiplier": 0.000000,
//	"m_flEnemyMovementSpeedMultiplier": 0.000000,
//	"m_flEnemyTurnRateMultiplier": 0.000000,
//	"m_flEnemySpawnCountMuliplier": 0.000000,
//	"m_flEnemyTouchMovementSlowDuration": 0.000000,
//	"m_flXPDropChanceMultiplier": 0.000000,
//	"m_flXPLevelUpRequirementMultiplier": 0.000000,
//	"m_flAdditionalFirstFloorTime": 0.000000,
//	"m_bEnableMeteorModifier": false,
//	"m_vecAdditionalEnemySpawners":
//	[
//	],
//	"m_vecAdditionalEnemyEvents":
//	[
//	],
//	"m_vecAdditionalStartingPowerUps":
//	[
//	],
//	"m_vecOverrideImperiaEnrageHealthThresholds":
//	[
//	]
//}
// MVDataRoot
class CSurvivorsDifficultyDefinition
{
	CUtlString m_sLocDifficultyName;
	CUtlString m_sLocDifficultyDescription;
	CUtlString m_sLocDifficultyUpgradeText;
	float32 m_flPlayerMaxHPMultiplier;
	float32 m_flPlayerHPRegenerationMultiplier;
	float32 m_flEnemyHealthMultiplier;
	float32 m_flEnemyDamageMultiplier;
	float32 m_flEnemyMovementSpeedMultiplier;
	float32 m_flEnemyTurnRateMultiplier;
	float32 m_flEnemySpawnCountMuliplier;
	float32 m_flEnemyTouchMovementSlowDuration;
	float32 m_flXPDropChanceMultiplier;
	float32 m_flXPLevelUpRequirementMultiplier;
	float32 m_flAdditionalFirstFloorTime;
	bool m_bEnableMeteorModifier;
	CUtlVector< CSurvivorsSpawnerDefinition > m_vecAdditionalEnemySpawners;
	CUtlVector< CSurvivorsEnemyEventDefinition > m_vecAdditionalEnemyEvents;
	CUtlVector< SurvivorsPowerUpID_t > m_vecAdditionalStartingPowerUps;
	CUtlVector< float32 > m_vecOverrideImperiaEnrageHealthThresholds;
};

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
};

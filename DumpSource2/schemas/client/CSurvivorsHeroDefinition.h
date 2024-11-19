class CSurvivorsHeroDefinition
{
	SurvivorsHeroID_t m_unHeroID;
	HeroID_t m_nDOTAHeroID;
	float32 m_flBaseHealth;
	float32 m_flBaseSpeed;
	float32 m_flBasePickupRadius;
	float32 m_flBaseDashSpeed;
	float32 m_flBaseDashDuration;
	float32 m_flBaseDashCooldown;
	int32 m_nBaseNumDashes;
	float32 m_flMass;
	float32 m_flCollisionRadius;
	float32 m_flCollisionHeight;
	float32 m_flTriggerCollisionRadiusPadding;
	CUtlString m_pszPlayerHitSoundEvent;
	CUtlString m_sLocDisplayName;
	CUtlVector< item_definition_index_t > m_vecEconItems;
	style_index_t m_unStyleIndex;
	CUtlVector< CSurvivorsAttributeValue > m_vecBaseAttributes;
	CUtlVector< SurvivorsPowerUpID_t > m_vecStartingPowerUps;
	CUtlVector< SurvivorsPowerUpID_t > m_vecInnatePowerUps;
};

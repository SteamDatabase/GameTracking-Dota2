// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MVDataRoot
class CSurvivorsPowerUpDefinition
{
	SurvivorsPowerUpID_t m_unPowerUpID;
	int32 m_nMaxLevel;
	CUtlVector< SurvivorsAttributeType_t > m_vecTooltipAttributes;
	CUtlVector< SurvivorsAttributeType_t > m_vecScepterTooltipAttributes;
	CUtlVector< CSurvivorsAttributeValue > m_vecBaseAttributes;
	CUtlVector< SurvivorsPowerUpID_t > m_vecRecipeItems;
	bool m_bIsPassive;
	bool m_bIsInnate;
	bool m_bIsGold;
	bool m_bRollable;
	bool m_bIsShardUpgradeable;
	bool m_bIsScepterUpgradeable;
	CPanoramaImageName m_sImage;
	CUtlString m_sSource;
	CPanoramaImageName m_sHeroImage;
	CUtlString m_sLocAbilityName;
	CUtlString m_sLocAbilityDesc;
	CUtlString m_sLocShardAbilityDesc;
	CUtlString m_sLocScepterAbilityDesc;
	CUtlString m_sLocHeroName;
	CUtlVector< CSurvivorsUpgradeDefinition > m_vecMinorUpgradeChoices;
	CUtlVector< CSurvivorsUpgradeDefinition > m_vecAuthoredUpgradeChoices;
	CSurvivorsUpgradeDefinition m_scepterUpgradeDefinition;
	bool m_bModifierParticleUsesOverheadOffset;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sModifierParticle;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sStunParticle;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sVulnerableParticle;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sFreezeParticle;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sHitStatusEffectParticle;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sWarmupEffectParticle;
	Vector m_vWarmupEffectColor;
	float32 m_flWarmupEffectTime;
	float32 m_flSpawnPickupOnKillPercent;
	SurvivorsPickupID_t m_unSpawnPickupOnKillID;
};

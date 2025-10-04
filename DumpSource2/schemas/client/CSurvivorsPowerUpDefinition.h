// MGetKV3ClassDefaults = {
//	"_class": "CSurvivorsPowerUpDefinition",
//	"m_unPowerUpID": 0,
//	"m_nMaxLevel": 0,
//	"m_vecTooltipAttributes":
//	[
//	],
//	"m_vecScepterTooltipAttributes":
//	[
//	],
//	"m_vecBaseAttributes":
//	[
//	],
//	"m_vecRecipeItems":
//	[
//	],
//	"m_bIsPassive": false,
//	"m_bIsInnate": false,
//	"m_bIsGold": false,
//	"m_bRollable": true,
//	"m_bIsShardUpgradeable": false,
//	"m_bIsScepterUpgradeable": false,
//	"m_sImage": "",
//	"m_sSource": "",
//	"m_sHeroImage": "",
//	"m_sLocAbilityName": "",
//	"m_sLocAbilityDesc": "",
//	"m_sLocShardAbilityDesc": "",
//	"m_sLocScepterAbilityDesc": "",
//	"m_sLocHeroName": "",
//	"m_vecMinorUpgradeChoices":
//	[
//	],
//	"m_vecAuthoredUpgradeChoices":
//	[
//	],
//	"m_scepterUpgradeDefinition":
//	{
//		"m_unRarity": "RARITY_INVALID",
//		"m_vecUpgradeAttributes":
//		[
//		],
//		"m_vecGlobalUpgradeAttributes":
//		[
//		]
//	},
//	"m_bModifierParticleUsesOverheadOffset": true,
//	"m_sModifierParticle": "",
//	"m_sStunParticle": "",
//	"m_sVulnerableParticle": "",
//	"m_sFreezeParticle": "",
//	"m_sHitStatusEffectParticle": "",
//	"m_sWarmupEffectParticle": "",
//	"m_vWarmupEffectColor":
//	[
//		0.000000,
//		0.000000,
//		0.000000
//	],
//	"m_flWarmupEffectTime": -1.000000,
//	"m_flSpawnPickupOnKillPercent": 0.000000,
//	"m_unSpawnPickupOnKillID": 0
//}
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

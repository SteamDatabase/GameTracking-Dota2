// MGetKV3ClassDefaults = {
//	"_class": "CSurvivorsPowerUpDefinition_MortimerKisses",
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
//		0.000510,
//		0.000000,
//		0.000000
//	],
//	"m_flWarmupEffectTime": -1.000000,
//	"m_flSpawnPickupOnKillPercent": 0.000000,
//	"m_unSpawnPickupOnKillID": 0,
//	"m_eOrigin": "INVALID_ORIGIN",
//	"m_flRemoveParticleTimeDelay": 0.000000,
//	"m_sParticle": "",
//	"m_sHitImpactParticle": "",
//	"m_flMinRange": 0.000000,
//	"m_flLaunchDistance": 0.000000,
//	"m_flScepterLaunchDistance": 0.000000,
//	"m_flAnglePerShot": 0.000000,
//	"m_sArtilleryParticle": ""
//}
// MVDataRoot
class CSurvivorsPowerUpDefinition_MortimerKisses : public CSurvivorsPowerUpDefinition_AreaAttack_Circle
{
	float32 m_flMinRange;
	float32 m_flLaunchDistance;
	float32 m_flScepterLaunchDistance;
	float32 m_flAnglePerShot;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sArtilleryParticle;
};

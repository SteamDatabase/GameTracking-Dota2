// MGetKV3ClassDefaults = {
//	"_class": "CSurvivorsPowerUpDefinition_CounterHelix",
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
//	"m_unSpawnPickupOnKillID": 0,
//	"m_eOrigin": "INVALID_ORIGIN",
//	"m_flRemoveParticleTimeDelay": 0.000000,
//	"m_sParticle": "",
//	"m_sHitImpactParticle": "",
//	"m_flChanceToCounter": 0.000000,
//	"m_flDelayBetweenCounters": 0.000000
//}
// MVDataRoot
class CSurvivorsPowerUpDefinition_CounterHelix : public CSurvivorsPowerUpDefinition_AreaAttack_Circle
{
	float32 m_flChanceToCounter;
	float32 m_flDelayBetweenCounters;
};

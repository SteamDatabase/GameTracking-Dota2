// MGetKV3ClassDefaults = {
//	"m_unGameModeID": 0,
//	"m_vCameraOffset":
//	[
//		0.000000,
//		0.000000,
//		0.000000
//	],
//	"m_flEnemyRadius": 0.000000,
//	"m_flEnemyRadiusVariance": 0.000000,
//	"m_flEnemyDespawnBuffer": 0.000000,
//	"m_flEnemyDespawnTime": 1.000000,
//	"m_sLevelName": "",
//	"m_flRequiredExperienceBase": 0.000000,
//	"m_flRequiredExperienceExponent": -nan,
//	"m_TimeBasedLightingEnvironments":
//	[
//		{
//			"vecLightDirection":
//			[
//				-nan,
//				0.000000,
//				0.000000
//			],
//			"flGlobalLightScale": 0.000000,
//			"flPointLightScale": 0.000000,
//			"cLightColor":
//			[
//				0,
//				0,
//				0,
//				0
//			],
//			"cAmbientColor":
//			[
//				0,
//				0,
//				0,
//				0
//			],
//			"cShadowColor":
//			[
//				0,
//				0,
//				0,
//				0
//			],
//			"cShadowSecondaryColor":
//			[
//				0,
//				0,
//				0,
//				0
//			],
//			"cSpecularColor":
//			[
//				0,
//				0,
//				0,
//				0
//			]
//		},
//		{
//			"vecLightDirection":
//			[
//				0.000000,
//				0.000000,
//				0.000000
//			],
//			"flGlobalLightScale": 0.000000,
//			"flPointLightScale": 0.000000,
//			"cLightColor":
//			[
//				0,
//				0,
//				0,
//				0
//			],
//			"cAmbientColor":
//			[
//				0,
//				0,
//				0,
//				0
//			],
//			"cShadowColor":
//			[
//				0,
//				0,
//				0,
//				0
//			],
//			"cShadowSecondaryColor":
//			[
//				0,
//				0,
//				0,
//				0
//			],
//			"cSpecularColor":
//			[
//				0,
//				0,
//				0,
//				0
//			]
//		},
//		{
//			"vecLightDirection":
//			[
//				-0.000000,
//				0.000000,
//				0.000000
//			],
//			"flGlobalLightScale": 0.000000,
//			"flPointLightScale": -nan,
//			"cLightColor":
//			[
//				0,
//				0,
//				0,
//				0
//			],
//			"cAmbientColor":
//			[
//				0,
//				0,
//				0,
//				0
//			],
//			"cShadowColor":
//			[
//				0,
//				0,
//				0,
//				0
//			],
//			"cShadowSecondaryColor":
//			[
//				0,
//				0,
//				0,
//				0
//			],
//			"cSpecularColor":
//			[
//				0,
//				0,
//				0,
//				0
//			]
//		}
//	],
//	"m_sDifficultyName": "",
//	"m_flPlayerReviveTimer": 2.000000,
//	"m_sReviveEffect": "",
//	"m_nMaxActiveSlots": 0,
//	"m_nMaxPassiveSlots": 0,
//	"m_nLevelUpChoices": 0,
//	"m_nMaxXPPickupsInWorld": 300,
//	"m_flKnockbackDuration": 0.200000,
//	"m_flSeperationVelocityInfluence": 0.700000,
//	"m_flSeperationVelocityInterpolationSpeed": 10.000000,
//	"m_flPlayerPositionHistoryBufferDuration": 0.400000,
//	"m_flExistingItemGenerationWeight": 0.000000,
//	"m_flNewItemGenerationWeight": 0.000000,
//	"m_flPassiveItemGenerationWeight": 0.000000,
//	"m_flFirstFloorTimeLimit": 0.000000,
//	"m_flEliteRoomTriggerChannelTime": 0.000000,
//	"m_flEliteRoomTriggerRadius": 0.000000,
//	"m_nInitialItemSpawns": 0,
//	"m_nInitialMagnetSpawns": 0,
//	"m_vecEliteRoomUnlockTimes":
//	[
//	],
//	"m_sEliteRoomChannelEffect": "",
//	"m_sEliteRoomDirectionalArrowEffect": "",
//	"m_vecEliteRoomChoices":
//	[
//	],
//	"m_sHealthBarEffect": "",
//	"m_sAttackIndicatorParticleEffect": "",
//	"m_sDamageNumbersEffectEnemy": "",
//	"m_sDamageNumbersEffectPlayer": "",
//	"m_sDamageNumbersEffectCriticalStrike": "",
//	"m_sCollisionIndicatorEffect": "",
//	"m_vCollisionIndicatorColorPlayer":
//	[
//		1329075499443421184.000000,
//		0.000000,
//		-2.095940
//	],
//	"m_vCollisionIndicatorColorEnemy":
//	[
//		0.000000,
//		-2.096275,
//		0.000000
//	],
//	"m_sPhysicalWeaknessEffect": "",
//	"m_sGenericStunEffect": "",
//	"m_cEliteGlowColor":
//	[
//		0,
//		0,
//		0,
//		0
//	],
//	"m_flLevelUpDelay": 0.000000,
//	"m_flLevelUpKnockbackRadius": 0.000000,
//	"m_flLevelUpKnockbackDistance": 100.000000,
//	"m_sLevelUpEffect": "",
//	"m_sLevelUpKnockbackEffect": "",
//	"m_sPlayerHitEffect": "",
//	"m_vecSeperationLayerData":
//	[
//	],
//	"m_luckyLootTable":
//	{
//		"m_vecLootEntryCollections":
//		[
//		]
//	}
//}
// MVDataRoot
class CSurvivorsGameModeDefinition
{
	SurvivorsGameModeID_t m_unGameModeID;
	Vector m_vCameraOffset;
	float32 m_flEnemyRadius;
	float32 m_flEnemyRadiusVariance;
	float32 m_flEnemyDespawnBuffer;
	float32 m_flEnemyDespawnTime;
	CUtlString m_sLevelName;
	float32 m_flRequiredExperienceBase;
	float32 m_flRequiredExperienceExponent;
	CrownfallSurvivorsLightingEnvironment_t[3] m_TimeBasedLightingEnvironments;
	CUtlString m_sDifficultyName;
	float32 m_flPlayerReviveTimer;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sReviveEffect;
	int32 m_nMaxActiveSlots;
	int32 m_nMaxPassiveSlots;
	int32 m_nLevelUpChoices;
	int32 m_nMaxXPPickupsInWorld;
	float32 m_flKnockbackDuration;
	float32 m_flSeperationVelocityInfluence;
	float32 m_flSeperationVelocityInterpolationSpeed;
	float32 m_flPlayerPositionHistoryBufferDuration;
	float32 m_flExistingItemGenerationWeight;
	float32 m_flNewItemGenerationWeight;
	float32 m_flPassiveItemGenerationWeight;
	float32 m_flFirstFloorTimeLimit;
	float32 m_flEliteRoomTriggerChannelTime;
	float32 m_flEliteRoomTriggerRadius;
	int32 m_nInitialItemSpawns;
	int32 m_nInitialMagnetSpawns;
	CUtlVector< float32 > m_vecEliteRoomUnlockTimes;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sEliteRoomChannelEffect;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sEliteRoomDirectionalArrowEffect;
	CUtlVector< CUtlString > m_vecEliteRoomChoices;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sHealthBarEffect;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sAttackIndicatorParticleEffect;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sDamageNumbersEffectEnemy;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sDamageNumbersEffectPlayer;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sDamageNumbersEffectCriticalStrike;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sCollisionIndicatorEffect;
	Vector m_vCollisionIndicatorColorPlayer;
	Vector m_vCollisionIndicatorColorEnemy;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sPhysicalWeaknessEffect;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sGenericStunEffect;
	Color m_cEliteGlowColor;
	float32 m_flLevelUpDelay;
	float32 m_flLevelUpKnockbackRadius;
	float32 m_flLevelUpKnockbackDistance;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sLevelUpEffect;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sLevelUpKnockbackEffect;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sPlayerHitEffect;
	CUtlVector< CSurvivorsGameModeDefinition::SeparationLayerData > m_vecSeperationLayerData;
	CSurvivorsLootTable m_luckyLootTable;
};

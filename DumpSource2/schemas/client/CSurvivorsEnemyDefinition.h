// MGetKV3ClassDefaults = {
//	"_class": "CSurvivorsEnemyDefinition",
//	"m_unEnemyID": 0,
//	"m_vecModelNames":
//	[
//	],
//	"m_sStatsName": "",
//	"m_sDisplayName": "",
//	"m_sImageThumbnail": "",
//	"m_bUseHeroModel": false,
//	"m_nDOTAHeroID": 0,
//	"m_vecEconItems":
//	[
//	],
//	"m_unStyleIndex": 255,
//	"m_sSkinName": "",
//	"m_sSkinNames":
//	[
//	],
//	"m_flTouchDamage": 0.000000,
//	"m_bDieOnTouch": false,
//	"m_vecAttacks":
//	[
//	],
//	"m_vecPickupChances":
//	[
//	],
//	"m_vecLootTable":
//	[
//	],
//	"m_fullLootTable":
//	{
//		"m_vecLootEntryCollections":
//		[
//		]
//	},
//	"m_flMaxHealth": 10.000000,
//	"m_flMaxHealthPerPlayerLevel": 0.000000,
//	"m_flMoveSpeed": 50.000000,
//	"m_flModelScale": 1.000000,
//	"m_flMaxModelScaleVariance": 0.050000,
//	"m_flCollisionRadius": 30.000000,
//	"m_bHasSolidBody": false,
//	"m_bUndespawnable": false,
//	"m_flOverrideDespawnRadiusBuffer": -1.000000,
//	"m_bHasDeathAnimation": true,
//	"m_bDissolveOnDeath": true,
//	"m_flDeathDuration": 0.500000,
//	"m_flDeathEffect_DissolveEdgeWidth": 0.050000,
//	"m_flDeathEffect_DissolveScale": 200.000000,
//	"m_flDeathEffect_DissolveColor":
//	[
//		0.100000,
//		0.000000,
//		0.000000
//	],
//	"m_bRandomFacing": true,
//	"m_bPlayerFacing": false,
//	"m_vFixedFacing":
//	[
//		0.000000,
//		0.000000
//	],
//	"m_sDeathEffectParticle": "",
//	"m_flMoveAnimPlaybackRate": 1.000000,
//	"m_flIdleAnimPlaybackRate": 1.000000,
//	"m_flTurnRate": 75.000000,
//	"m_flSinMovementAngle": 90.000000,
//	"m_flSinMovementPeriodMultiplier": 1.000000,
//	"m_flMass": 1.000000,
//	"m_flKnockbackResistance": 0.000000,
//	"m_flStatusResistance": 0.000000,
//	"m_bIsElite": false,
//	"m_bIsMiniboss": false,
//	"m_bIsDestructible": false,
//	"m_bHasGlowOutline": false,
//	"m_bOverrideGlowColor": false,
//	"m_cOverriddenGlowColor":
//	[
//		0,
//		0,
//		0,
//		0
//	],
//	"m_bShowHealthBar": false,
//	"m_bCenterRooted": false,
//	"m_bRotates": false,
//	"m_bRandomizeSinTurnTimerOnSpawn": true,
//	"m_bInvulnerable": false,
//	"m_bPlayerFriendly": false,
//	"m_nSplitOnDeathNumUnits": -1,
//	"m_unSplitOnDeathEnemyID": 0,
//	"m_flSplitOnDeathKnockbackDistance": 50.000000,
//	"m_eMovementBehavior": "ENEMY_MOVEMENT_BEHAVIOR_INVALID",
//	"m_eMovementCapability": "ENEMY_MOVEMENT_CAPABILITY_INVALID",
//	"m_activityIdle": "ACT_DOTA_IDLE",
//	"m_activityMove": "ACT_DOTA_RUN",
//	"m_activityDie": "ACT_DOTA_DISABLED",
//	"m_activityDisabled": "ACT_DOTA_DISABLED",
//	"m_bPlayDeathSound": false,
//	"m_eSeparationLayer": "SMALL"
//}
// MVDataRoot
class CSurvivorsEnemyDefinition
{
	SurvivorsEnemyID_t m_unEnemyID;
	CUtlVector< CResourceNameTyped< CWeakHandle< InfoForResourceTypeCModel > > > m_vecModelNames;
	CUtlString m_sStatsName;
	CUtlString m_sDisplayName;
	CPanoramaImageName m_sImageThumbnail;
	bool m_bUseHeroModel;
	HeroID_t m_nDOTAHeroID;
	CUtlVector< item_definition_index_t > m_vecEconItems;
	style_index_t m_unStyleIndex;
	CUtlString m_sSkinName;
	CUtlVector< CUtlString > m_sSkinNames;
	float32 m_flTouchDamage;
	bool m_bDieOnTouch;
	CUtlVector< CSurvivorsEnemyDefinition::Attack > m_vecAttacks;
	CUtlVector< CSurvivorsEnemyDefinition::PickupChance > m_vecPickupChances;
	CUtlVector< CSurvivorsEnemyDefinition::PickupChance > m_vecLootTable;
	CSurvivorsLootTable m_fullLootTable;
	float32 m_flMaxHealth;
	float32 m_flMaxHealthPerPlayerLevel;
	float32 m_flMoveSpeed;
	float32 m_flModelScale;
	float32 m_flMaxModelScaleVariance;
	float32 m_flCollisionRadius;
	bool m_bHasSolidBody;
	bool m_bUndespawnable;
	float32 m_flOverrideDespawnRadiusBuffer;
	bool m_bHasDeathAnimation;
	bool m_bDissolveOnDeath;
	float32 m_flDeathDuration;
	float32 m_flDeathEffect_DissolveEdgeWidth;
	float32 m_flDeathEffect_DissolveScale;
	Vector m_flDeathEffect_DissolveColor;
	bool m_bRandomFacing;
	bool m_bPlayerFacing;
	Vector2D m_vFixedFacing;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sDeathEffectParticle;
	float32 m_flMoveAnimPlaybackRate;
	float32 m_flIdleAnimPlaybackRate;
	float32 m_flTurnRate;
	float32 m_flSinMovementAngle;
	float32 m_flSinMovementPeriodMultiplier;
	float32 m_flMass;
	float32 m_flKnockbackResistance;
	float32 m_flStatusResistance;
	bool m_bIsElite;
	bool m_bIsMiniboss;
	bool m_bIsDestructible;
	bool m_bHasGlowOutline;
	bool m_bOverrideGlowColor;
	Color m_cOverriddenGlowColor;
	bool m_bShowHealthBar;
	bool m_bCenterRooted;
	bool m_bRotates;
	bool m_bRandomizeSinTurnTimerOnSpawn;
	bool m_bInvulnerable;
	bool m_bPlayerFriendly;
	int32 m_nSplitOnDeathNumUnits;
	SurvivorsEnemyID_t m_unSplitOnDeathEnemyID;
	float32 m_flSplitOnDeathKnockbackDistance;
	ESurvivorsEnemyMovementBehavior m_eMovementBehavior;
	ESurvivorsEnemyMovementCapability m_eMovementCapability;
	GameActivity_t m_activityIdle;
	GameActivity_t m_activityMove;
	GameActivity_t m_activityDie;
	GameActivity_t m_activityDisabled;
	bool m_bPlayDeathSound;
	ESurvivorsEnemySeparationLayer m_eSeparationLayer;
};

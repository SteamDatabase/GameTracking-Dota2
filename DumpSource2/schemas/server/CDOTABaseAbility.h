// MNetworkExcludeByName = "m_angRotation"
// MNetworkExcludeByName = "m_blinktoggle"
// MNetworkExcludeByName = "m_cellX"
// MNetworkExcludeByName = "m_cellY"
// MNetworkExcludeByName = "m_cellZ"
// MNetworkExcludeByUserGroup = "m_flCycle"
// MNetworkExcludeByName = "m_flEncodedController"
// MNetworkExcludeByName = "m_flPoseParameter"
// MNetworkExcludeByName = "m_flSimulationTime"
// MNetworkExcludeByName = "m_flexWeight"
// MNetworkExcludeByName = "m_nForceBone"
// MNetworkExcludeByName = "m_nHitboxSet"
// MNetworkExcludeByName = "m_baseLayer.m_hSequence"
// MNetworkExcludeByName = "m_vecForce"
// MNetworkExcludeByName = "m_vecMaxs"
// MNetworkExcludeByName = "m_vecMins"
// MNetworkExcludeByName = "m_vecOrigin"
// MNetworkExcludeByName = "m_vecSpecifiedSurroundingMaxs"
// MNetworkExcludeByName = "m_vecSpecifiedSurroundingMins"
// MNetworkExcludeByName = "m_vLookTargetPosition"
// MNetworkExcludeByUserGroup = "overlay_vars"
// MNetworkExcludeByName = "m_hOwnerEntity"
// MNetworkExcludeByName = "m_hParent"
// MNetworkExcludeByName = "m_flCreateTime"
// MNetworkExcludeByName = "m_flScale"
// MNetworkVarNames = "bool m_bRefCountsModifiers"
// MNetworkVarNames = "bool m_bHidden"
// MNetworkVarNames = "bool m_bActivated"
// MNetworkVarNames = "AbilityBarType_t m_nAbilityBarType"
// MNetworkVarNames = "int m_iDirtyButtons"
// MNetworkVarNames = "int m_iLevel"
// MNetworkVarNames = "bool m_bToggleState"
// MNetworkVarNames = "bool m_bInAbilityPhase"
// MNetworkVarNames = "float m_flAbilityMuteDuration"
// MNetworkVarNames = "float m_fCooldown"
// MNetworkVarNames = "float m_flCooldownLength"
// MNetworkVarNames = "int m_iManaCost"
// MNetworkVarNames = "bool m_bAutoCastState"
// MNetworkVarNames = "bool m_bAltCastState"
// MNetworkVarNames = "GameTime_t m_flChannelStartTime"
// MNetworkVarNames = "GameTime_t m_flCastStartTime"
// MNetworkVarNames = "bool m_bInIndefiniteCooldown"
// MNetworkVarNames = "bool m_bFrozenCooldown"
// MNetworkVarNames = "float m_flOverrideCastPoint"
// MNetworkVarNames = "bool m_bStolen"
// MNetworkVarNames = "bool m_bReplicated"
// MNetworkVarNames = "bool m_bStealable"
// MNetworkVarNames = "int m_nAbilityCurrentCharges"
// MNetworkVarNames = "float m_fAbilityChargeRestoreTimeRemaining"
// MNetworkVarNames = "bool m_bUpgradeRecommended"
// MNetworkVarNames = "int m_nMaxLevelOverride"
// MNetworkVarNames = "int m_nRequiredLevelOverride"
// MNetworkVarNames = "int m_nLevelsBetweenUpgradesOverride"
// MNetworkVarNames = "HeroFacetKey_t m_nHeroFacetKey"
// MNetworkVarNames = "float m_flTotalExtendedChannelTime"
// MNetworkVarNames = "bool m_bGrantedByFacet"
// MNetworkVarNames = "bool m_bReflection"
// MNetworkVarNames = "EHANDLE m_pReflectionSourceAbility"
// MNetworkVarNames = "EHANDLE m_hHiddenAbilityForDisplay"
class CDOTABaseAbility : public CBaseEntity
{
	int32 m_iAbilityIndex;
	int32 m_nStolenActivity;
	bool m_bChanneling;
	bool m_bRedirected;
	// MNetworkEnable
	bool m_bRefCountsModifiers;
	int32 m_iModifierRefCount;
	bool m_bWantsToNeutralCast;
	CHandle< CBaseEntity > m_hNeutralCastTarget;
	bool m_bServerOnlyAbility;
	bool m_bGrantedAbilityChargesFromScepter;
	bool m_bGrantedAbilityChargesFromShard;
	bool m_bIsDefaultHeroAbility;
	bool m_bConsiderOvershootInGetCastRange;
	float32 m_flExtendChannelTime;
	bool m_bDisableSharedCooldown;
	// MNetworkEnable
	bool m_bHidden;
	// MNetworkEnable
	bool m_bActivated;
	// MNetworkEnable
	AbilityBarType_t m_nAbilityBarType;
	// MNetworkEnable
	int32 m_iDirtyButtons;
	// MNetworkEnable
	// MNetworkPriority = 32
	int32 m_iLevel;
	// MNetworkEnable
	bool m_bToggleState;
	// MNetworkEnable
	// MNetworkPriority = 32
	bool m_bInAbilityPhase;
	// MNetworkEnable
	float32 m_flAbilityMuteDuration;
	// MNetworkEnable
	// MNetworkPriority = 32
	float32 m_fCooldown;
	// MNetworkEnable
	// MNetworkBitCount = 15
	// MNetworkMinValue = 0.000000
	// MNetworkMaxValue = 1024.000000
	float32 m_flCooldownLength;
	// MNetworkEnable
	// MNetworkPriority = 32
	int32 m_iManaCost;
	// MNetworkEnable
	// MNetworkPriority = 32
	bool m_bAutoCastState;
	// MNetworkEnable
	// MNetworkPriority = 32
	bool m_bAltCastState;
	// MNetworkEnable
	GameTime_t m_flChannelStartTime;
	// MNetworkEnable
	GameTime_t m_flCastStartTime;
	// MNetworkEnable
	bool m_bInIndefiniteCooldown;
	// MNetworkEnable
	bool m_bFrozenCooldown;
	int32 m_nFrozenCooldownStack;
	// MNetworkEnable
	float32 m_flOverrideCastPoint;
	// MNetworkEnable
	bool m_bStolen;
	// MNetworkEnable
	bool m_bReplicated;
	// MNetworkEnable
	bool m_bStealable;
	// MNetworkEnable
	int32 m_nAbilityCurrentCharges;
	// MNetworkEnable
	// MNetworkPriority = 32
	float32 m_fAbilityChargeRestoreTimeRemaining;
	// MNetworkEnable
	bool m_bUpgradeRecommended;
	// MNetworkEnable
	int32 m_nMaxLevelOverride;
	// MNetworkEnable
	int32 m_nRequiredLevelOverride;
	// MNetworkEnable
	int32 m_nLevelsBetweenUpgradesOverride;
	// MNetworkEnable
	HeroFacetKey_t m_nHeroFacetKey;
	// MNetworkEnable
	float32 m_flTotalExtendedChannelTime;
	// MNetworkEnable
	bool m_bGrantedByFacet;
	// MNetworkEnable
	bool m_bReflection;
	// MNetworkEnable
	CHandle< CBaseEntity > m_pReflectionSourceAbility;
	// MNetworkEnable
	CHandle< CBaseEntity > m_hHiddenAbilityForDisplay;
	CHandle< CBaseEntity > m_hReflectionCause;
	item_definition_index_t m_nBackedByEconItemIndex;
	bool m_bAltCastOrdered;
};

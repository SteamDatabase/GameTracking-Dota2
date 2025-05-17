// MNetworkExcludeByName = "m_angRotation"
// MNetworkExcludeByName = "m_flAnimTime"
// MNetworkExcludeByUserGroup = "m_flCycle"
// MNetworkExcludeByName = "m_flPlaybackRate"
// MNetworkExcludeByName = "m_flPoseParameter"
// MNetworkExcludeByName = "m_flSimulationTime"
// MNetworkExcludeByName = "m_baseLayer.m_hSequence"
// MNetworkExcludeByName = "m_vecVelocity"
// MNetworkExcludeByName = "m_flexWeight"
// MNetworkExcludeByUserGroup = "overlay_vars"
// MNetworkExcludeByName = "m_nTickBase"
// MNetworkVarNames = "bool m_bUsingCameraMan"
// MNetworkVarNames = "bool m_bUsingAssistedCameraOperator"
// MNetworkVarNames = "int m_nPlayerAssistFlags"
// MNetworkVarNames = "PlayerID_t m_nPlayerID"
// MNetworkVarNames = "CHandle< CBaseEntity> m_hAssignedHero"
// MNetworkVarNames = "CHandle< CBaseEntity> m_hKillCamUnit"
// MNetworkVarNames = "int m_nCachedCoachedTeam"
// MNetworkVarNames = "int m_nServerOrderSequenceNumber"
// MNetworkVarNames = "int m_iCursor"
// MNetworkVarNames = "int m_iSpectatorClickBehavior"
// MNetworkVarNames = "float m_flAspectRatio"
// MNetworkVarNames = "CHandle< CBaseEntity> m_hSpectatorQueryUnit"
// MNetworkVarNames = "int m_iStatsPanel"
// MNetworkVarNames = "int m_iShopPanel"
// MNetworkVarNames = "ShopItemViewMode_t m_iShopViewMode"
// MNetworkVarNames = "int m_iStatsDropdownCategory"
// MNetworkVarNames = "int m_iStatsDropdownSort"
// MNetworkVarNames = "char m_szShopString"
// MNetworkVarNames = "ClientQuickBuyItemState m_vecClientQuickBuyState"
// MNetworkVarNames = "bool m_bInShowCaseMode"
// MNetworkVarNames = "float m_flCameraZoomAmount"
// MNetworkVarNames = "int m_iHighPriorityScore"
// MNetworkVarNames = "AbilityID_t m_quickBuyItems"
// MNetworkVarNames = "bool m_quickBuyIsPurchasable"
// MNetworkVarNames = "float m_flUnfilteredFrameTime"
// MNetworkVarNames = "int m_iMusicStatus"
// MNetworkVarNames = "float m_flMusicOperatorVals"
// MNetworkVarNames = "int m_iMusicOperatorVals"
// MNetworkReplayCompatField = "m_iPlayerID"
// MNetworkReplayCompatField = "m_audio\..*"
class C_DOTAPlayerController : public CBasePlayerController
{
	int32 m_iMinimapMove;
	KeyValues* m_pClickBehaviorKeys;
	GameTime_t m_flCenterTime;
	int32 m_iConfirmationIndex;
	bool m_bCenterOnHero;
	bool m_bHeroAssigned;
	int32 m_nKeyBindHeroID;
	// MNetworkEnable
	bool m_bUsingCameraMan;
	// MNetworkEnable
	bool m_bUsingAssistedCameraOperator;
	// MNetworkEnable
	int32 m_nPlayerAssistFlags;
	Vector m_vLatestEvent;
	CHandle< C_DOTABaseAbility > m_hFreeDrawAbility;
	Vector m_vLastFreeDrawPosition;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnPlayerIDChanged"
	PlayerID_t m_nPlayerID;
	// MNetworkEnable
	CHandle< C_BaseEntity > m_hAssignedHero;
	CHandle< C_BaseEntity > m_hLastAssignedHero;
	// MNetworkEnable
	CHandle< C_BaseEntity > m_hKillCamUnit;
	CHandle< C_BaseEntity > m_hPreviousKillCamUnit;
	float32 m_flKillCamUnitReceivedTime;
	int32 m_nRareLineClickCount;
	int32 m_nRareLinesPlayed;
	int32 m_nRareLineGroup;
	float32 m_flLastRareLinePlayTime;
	float32 m_flUnitOrdersSendTime;
	float32 m_flLastUnitOrdersSendTime;
	float32 m_flLastUnitOrdersTotalLatency;
	bool m_bTeleportRequiresHalt;
	bool m_bChannelRequiresHalt;
	bool m_bAutoPurchaseItems;
	bool m_bDisableHUDErrorMessages;
	int32 m_iMouseDragStartX;
	int32 m_iMouseDragStartY;
	int32 m_nWeatherType;
	bool m_bDynamicWeatherSystemActive;
	bool m_bDynamicSoundHandled;
	GameTime_t m_flDynamicWeatherNextSwitchTime;
	GameTime_t m_flDynamicWeatherScaleFinishedTime;
	float32 m_flDynamicWeatherIntensity;
	ParticleIndex_t m_nXPRangeFXIndex;
	ParticleIndex_t m_nVisionRangeFXIndex;
	CHandle< C_DOTABaseAbility > m_hRangeHintAbility;
	ParticleIndex_t m_nRangeHintFXIndex;
	float32 m_flRangeHintFXLastRadius;
	int32 m_nSelectedControlGroup;
	// MNetworkEnable
	int32 m_nCachedCoachedTeam;
	CHandle< C_DOTABaseAbility > m_hActiveAbility;
	CUtlVector< CUnitOrders > m_unitorders;
	int32 m_nNextOutgoingOrderSequenceNumber;
	// MNetworkEnable
	int32 m_nServerOrderSequenceNumber;
	int32 m_nMaxSentOutgoingOrderSequenceNumber;
	CUtlVector< CEntityIndex > m_nSelectedUnits;
	CUtlVector< ParticleIndex_t > m_nWaypoints;
	int32 m_iActions;
	CHandle< C_DOTA_BaseNPC > m_hQueryUnit;
	bool m_bInQuery;
	bool m_bSelectionChangedInDataUpdate;
	GameTime_t m_flQueryInhibitingActionTime;
	float32 m_flQueryInhibitDuration;
	CUtlVector< CHandle< C_BaseEntity > > m_RingedEntities;
	CUtlVector< CHandle< C_BaseEntity > > m_ActiveRingOwners;
	bool m_bOverridingQuery;
	float32 m_flLastAutoRepeatTime;
	float32 m_flConsumeDoubleclickTime;
	CUtlString m_LightInfoWeatherEffect;
	bool m_bPreviousWasLightInfoWeather;
	CUtlString m_MapDefaultWeatherEffect;
	bool m_bMapUsesDynamicWeather;
	int32 m_nCastRangeEffectCreationRadius;
	CUtlVector< ParticleIndex_t > m_vecSuggestedWardLocationEffects;
	C_DOTA_BaseNPC* m_pSmartCastNPC;
	ParticleIndex_t m_nTeamSprayParticleIndex;
	ParticleIndex_t m_nScanCastIndicatorParticleIndex;
	bool m_bIsNextCastOrderFromMouseClick;
	// MNetworkEnable
	// MNetworkUserGroup = "DOTACommentatorTable"
	// MNetworkPriority = 32
	int32[2] m_iCursor;
	// MNetworkEnable
	// MNetworkUserGroup = "DOTACommentatorTable"
	int32 m_iSpectatorClickBehavior;
	// MNetworkEnable
	// MNetworkUserGroup = "DOTACommentatorTable"
	float32 m_flAspectRatio;
	// MNetworkEnable
	// MNetworkUserGroup = "DOTACommentatorTable"
	CHandle< C_BaseEntity > m_hSpectatorQueryUnit;
	// MNetworkEnable
	// MNetworkUserGroup = "DOTACommentatorTable"
	int32 m_iStatsPanel;
	// MNetworkEnable
	// MNetworkUserGroup = "DOTACommentatorTable"
	int32 m_iShopPanel;
	// MNetworkEnable
	// MNetworkUserGroup = "DOTACommentatorTable"
	ShopItemViewMode_t m_iShopViewMode;
	// MNetworkEnable
	// MNetworkUserGroup = "DOTACommentatorTable"
	int32 m_iStatsDropdownCategory;
	// MNetworkEnable
	// MNetworkUserGroup = "DOTACommentatorTable"
	int32 m_iStatsDropdownSort;
	// MNetworkEnable
	// MNetworkUserGroup = "DOTACommentatorTable"
	char[64] m_szShopString;
	// MNetworkEnable
	// MNetworkUserGroup = "DOTACommentatorTable"
	C_UtlVectorEmbeddedNetworkVar< ClientQuickBuyItemState > m_vecClientQuickBuyState;
	// MNetworkEnable
	// MNetworkUserGroup = "DOTACommentatorTable"
	bool m_bInShowCaseMode;
	// MNetworkEnable
	// MNetworkUserGroup = "DOTACommentatorTable"
	float32 m_flCameraZoomAmount;
	// MNetworkEnable
	// MNetworkUserGroup = "DOTACommentatorTable"
	int32 m_iHighPriorityScore;
	// MNetworkEnable
	// MNetworkUserGroup = "DOTACommentatorTable"
	AbilityID_t[9] m_quickBuyItems;
	// MNetworkEnable
	// MNetworkUserGroup = "DOTACommentatorTable"
	bool[9] m_quickBuyIsPurchasable;
	// MNetworkEnable
	// MNetworkUserGroup = "DOTACommentatorTable"
	float32 m_flUnfilteredFrameTime;
	CUtlVector< NeutralCampStackPullAlarm_t > m_NeutralCampAlarms;
	int32[2] m_iPrevCursor;
	int32 m_iPositionHistoryTail;
	// MNetworkEnable
	int32 m_iMusicStatus;
	int32 m_iPreviousMusicStatus;
	bool m_bRequestedInventory;
	// MNetworkEnable
	float32[3] m_flMusicOperatorVals;
	// MNetworkEnable
	int32[4] m_iMusicOperatorVals;
	CUtlVector< sControlGroupElem >[10] m_ControlGroups;
	KeyValues* m_pkvControlGroupKV;
	float32 m_flAltHeldStartTime;
};

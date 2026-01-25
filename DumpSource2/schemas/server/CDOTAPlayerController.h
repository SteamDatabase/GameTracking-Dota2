// MNetworkUserGroupProxy = "CDOTAPlayerController"
// MNetworkExcludeByName = "m_angRotation"
// MNetworkExcludeByUserGroup = "m_flCycle"
// MNetworkExcludeByName = "m_flPlaybackRate"
// MNetworkExcludeByName = "m_flPoseParameter"
// MNetworkExcludeByName = "m_flSimulationTime"
// MNetworkExcludeByName = "m_baseLayer.m_hSequence"
// MNetworkExcludeByName = "m_vecVelocity"
// MNetworkExcludeByName = "m_flexWeight"
// MNetworkExcludeByUserGroup = "overlay_vars"
// MNetworkExcludeByName = "m_nTickBase"
// MNetworkUserGroupProxy = "CDOTAPlayerController"
// MNetworkUserGroupProxy = "CDOTAPlayerController"
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
// MNetworkVarNames = "bool m_bInShowCaseMode"
// MNetworkVarNames = "float m_flCameraZoomAmount"
// MNetworkVarNames = "int m_iHighPriorityScore"
// MNetworkVarNames = "float m_flUnfilteredFrameTime"
// MNetworkVarNames = "bool m_bUsingAssistedCameraOperator"
// MNetworkVarNames = "bool m_bUsingCameraMan"
// MNetworkVarNames = "int m_nPlayerAssistFlags"
// MNetworkVarNames = "int m_iMusicStatus"
// MNetworkVarNames = "float m_flMusicOperatorVals"
// MNetworkVarNames = "int m_iMusicOperatorVals"
// MNetworkVarNames = "CHandle< CBaseEntity> m_hKillCamUnit"
// MNetworkVarNames = "PlayerID_t m_nPlayerID"
// MNetworkVarNames = "CHandle< CBaseEntity> m_hAssignedHero"
// MNetworkVarNames = "int m_nServerOrderSequenceNumber"
// MNetworkVarNames = "int m_nCachedCoachedTeam"
// MNetworkUserGroupProxy = "CDOTAPlayerController"
class CDOTAPlayerController : public CBasePlayerController
{
	int32 m_iMinimapMove;
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
	CHandle< CBaseEntity > m_hSpectatorQueryUnit;
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
	bool m_bInShowCaseMode;
	// MNetworkEnable
	// MNetworkUserGroup = "DOTACommentatorTable"
	float32 m_flCameraZoomAmount;
	// MNetworkEnable
	// MNetworkUserGroup = "DOTACommentatorTable"
	int32 m_iHighPriorityScore;
	// MNetworkEnable
	// MNetworkUserGroup = "DOTACommentatorTable"
	float32 m_flUnfilteredFrameTime;
	// MNetworkEnable
	bool m_bUsingAssistedCameraOperator;
	// MNetworkEnable
	bool m_bUsingCameraMan;
	// MNetworkEnable
	int32 m_nPlayerAssistFlags;
	float32 m_flHighPriorityScoreTimeStamp;
	float32 m_flExecuteOrdersLagCompensation;
	// MNetworkEnable
	int32 m_iMusicStatus;
	// MNetworkEnable
	float32[3] m_flMusicOperatorVals;
	// MNetworkEnable
	int32[4] m_iMusicOperatorVals;
	CountdownTimer m_MusicRestTime;
	// MNetworkEnable
	CHandle< CBaseEntity > m_hKillCamUnit;
	Vector m_vecCrosshairTracePos;
	CEntityIndex m_iCrosshairEntity;
	// MNetworkEnable
	PlayerID_t m_nPlayerID;
	// MNetworkEnable
	CHandle< CBaseEntity > m_hAssignedHero;
	bool m_bTeleportRequiresHalt;
	bool m_bChannelRequiresHalt;
	bool m_bInteractionChannelsRequiresHalt;
	// MNetworkEnable
	// MNetworkUserGroup = "LocalPlayerExclusive"
	int32 m_nServerOrderSequenceNumber;
	float32 m_flLastOrderTime;
	float32 m_flLastKnownActiveTime;
	uint32 m_nLastOrderLatency;
	GameTime_t m_flLastReconnectTime;
	GameTime_t m_fLastSuggestionTime;
	bool m_bWantsRandomHero;
	bool m_bFullyJoinedServer;
	int32 m_nCheatDetectOrderReferenceCommandNumber;
	PlayerID_t m_iSwapPreferencePlayerID;
	uint32 m_nCoachListenMask;
	// MNetworkEnable
	int32 m_nCachedCoachedTeam;
	float32[2] m_flLastChatWheelTime;
	float32[2] m_flLastChatWheelAudioTime;
	float32[2] m_flLastChatWheelAllChatAudioTime;
	float32 m_flLastChatWheelSprayTime;
	float32 m_flLastChatWheelLongCooldownTime;
	float32 m_flLastPingTime;
	float32 m_flPingAllowance;
	float32 m_flLastMapLineTime;
	float32 m_flMapLineAllowance;
	float32 m_flLastWaypointPathPingTime;
	float32 m_flWaypointPathPingAllowance;
	float32 m_flLastVersusBehaviorTime;
	float32 m_flVersusBehaviorAllowance;
	uint8[10] m_pOrderRetirementHistory;
	uint16 m_nOrderRetirementSum;
	int32 m_nOrderRetirementLastTick;
};

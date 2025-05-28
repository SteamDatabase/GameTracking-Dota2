// MNetworkUserGroupProxy = "CDOTAPlayerPawn"
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
// MNetworkUserGroupProxy = "CDOTAPlayerPawn"
// MNetworkUserGroupProxy = "CDOTAPlayerPawn"
// MNetworkOverride = "m_vecOrigin CGameSceneNode"
// MNetworkOverride = "m_cellX CNetworkOriginCellCoordQuantizedVector"
// MNetworkOverride = "m_cellY CNetworkOriginCellCoordQuantizedVector"
// MNetworkOverride = "m_cellZ CNetworkOriginCellCoordQuantizedVector"
// MNetworkOverride = "m_vecX CNetworkOriginCellCoordQuantizedVector"
// MNetworkOverride = "m_vecY CNetworkOriginCellCoordQuantizedVector"
// MNetworkOverride = "m_vecZ CNetworkOriginCellCoordQuantizedVector"
// MNetworkVarTypeOverride = "CDOTAPlayer_CameraServices m_pCameraServices"
// MNetworkIncludeByName = "m_pCameraServices"
// MNetworkVarTypeOverride = "CDOTAPlayer_MovementServices m_pMovementServices"
// MNetworkIncludeByName = "m_pMovementServices"
// MNetworkVarNames = "CQuickBuyController m_quickBuyController"
// MNetworkVarNames = "PlayerID_t m_nPlayerID"
class CDOTAPlayerPawn : public CBasePlayerPawn
{
	// MNetworkEnable
	// MNetworkUserGroup = "DOTATeamMatesAndCommentatorTable"
	CQuickBuyController m_quickBuyController;
	// MNetworkEnable
	PlayerID_t m_nPlayerID;
	bool m_bIsHLTV;
	bool m_bIsTeamRestricted;
	int32 m_nTeamRestrictedTeamNum;
};

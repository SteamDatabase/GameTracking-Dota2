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
// MNetworkVarTypeOverride = "CDOTAPlayer_CameraServices m_pCameraServices"
// MNetworkIncludeByName = "m_pCameraServices"
// MNetworkVarTypeOverride = "CDOTAPlayer_MovementServices m_pMovementServices"
// MNetworkIncludeByName = "m_pMovementServices"
// MNetworkVarNames = "PlayerID_t m_nPlayerID"
class CDOTAPlayerPawn : public C_BasePlayerPawn
{
	// MNetworkEnable
	PlayerID_t m_nPlayerID;
};

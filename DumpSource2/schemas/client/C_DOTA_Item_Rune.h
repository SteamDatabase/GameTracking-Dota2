// MNetworkExcludeByUserGroup = "m_flCycle"
// MNetworkExcludeByName = "m_flPoseParameter"
// MNetworkExcludeByName = "m_flSimulationTime"
// MNetworkVarNames = "int m_iRuneType"
// MNetworkVarNames = "GameTime_t m_flRuneTime"
// MNetworkVarNames = "int m_nMapLocationTeam"
// MNetworkVarNames = "char m_szLocation"
class C_DOTA_Item_Rune : public CBaseAnimatingActivity
{
	// MNetworkEnable
	int32 m_iRuneType;
	// MNetworkEnable
	GameTime_t m_flRuneTime;
	// MNetworkEnable
	int32 m_nMapLocationTeam;
	// MNetworkEnable
	char[512] m_szLocation;
	int32 m_iOldRuneType;
	bool m_bShowingTooltip;
};

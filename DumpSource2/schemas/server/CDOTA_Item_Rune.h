// MNetworkExcludeByName = "m_flAnimTime"
// MNetworkExcludeByUserGroup = "m_flCycle"
// MNetworkExcludeByName = "m_flPoseParameter"
// MNetworkExcludeByName = "m_flSimulationTime"
// MNetworkVarNames = "int m_iRuneType"
// MNetworkVarNames = "float m_flRuneTime"
// MNetworkVarNames = "int m_nMapLocationTeam"
// MNetworkVarNames = "char m_szLocation"
class CDOTA_Item_Rune : public CBaseAnimatingActivity
{
	CHandle< CBaseEntity > m_hRuneSpawner;
	// MNetworkEnable
	int32 m_iRuneType;
	// MNetworkEnable
	// MNetworkBitCount = 4
	float32 m_flRuneTime;
	// MNetworkEnable
	int32 m_nMapLocationTeam;
	// MNetworkEnable
	char[512] m_szLocation;
};

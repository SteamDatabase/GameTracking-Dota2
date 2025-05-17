// MNetworkVarNames = "int m_iLastKillerTeam"
// MNetworkVarNames = "int m_iKillCount"
// MNetworkVarNames = "Vector m_vRoshanAltLocation"
// MNetworkVarNames = "EHANDLE m_hRoshan"
class C_DOTA_RoshanSpawner : public C_PointEntity
{
	// MNetworkEnable
	int32 m_iLastKillerTeam;
	// MNetworkEnable
	int32 m_iKillCount;
	// MNetworkEnable
	Vector m_vRoshanAltLocation;
	// MNetworkEnable
	CHandle< C_BaseEntity > m_hRoshan;
};

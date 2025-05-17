// MNetworkVarNames = "bool m_bEnabled"
// MNetworkVarNames = "bool m_bBlockFoW"
// MNetworkVarNames = "bool m_bBlockNav"
class CDOTA_SimpleObstruction : public CBaseEntity
{
	// MNetworkEnable
	bool m_bEnabled;
	// MNetworkEnable
	bool m_bBlockFoW;
	// MNetworkEnable
	bool m_bBlockNav;
	uint32 m_unOccluderID;
	bool m_bBlockingGridNav;
};

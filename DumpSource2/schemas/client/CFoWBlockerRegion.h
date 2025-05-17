// MNetworkVarNames = "FowBlocker_t m_vecFowBlockers"
// MNetworkVarNames = "float m_flMinX"
// MNetworkVarNames = "float m_flMaxX"
// MNetworkVarNames = "float m_flMinY"
// MNetworkVarNames = "float m_flMaxY"
// MNetworkVarNames = "float m_flGridSize"
class CFoWBlockerRegion : public C_BaseEntity
{
	// MNetworkEnable
	C_UtlVectorEmbeddedNetworkVar< FowBlocker_t > m_vecFowBlockers;
	// MNetworkEnable
	float32 m_flMinX;
	// MNetworkEnable
	float32 m_flMaxX;
	// MNetworkEnable
	float32 m_flMinY;
	// MNetworkEnable
	float32 m_flMaxY;
	// MNetworkEnable
	float32 m_flGridSize;
};

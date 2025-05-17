// MNetworkVarNames = "TrackedStatNetworkData_t m_vecTrackedStats"
class CBaseTrackedStatsEntity : public C_BaseEntity
{
	// MNetworkEnable
	// MNetworkChangeCallback = "OnTrackedStatsChanged"
	C_UtlVectorEmbeddedNetworkVar< TrackedStatNetworkData_t > m_vecTrackedStats;
};

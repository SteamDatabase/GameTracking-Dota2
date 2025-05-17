// MNetworkVarNames = "TrackedStatNetworkData_t m_vecTrackedStats"
class CBaseTrackedStatsEntity : public CBaseEntity
{
	// MNetworkEnable
	// MNetworkChangeCallback = "OnTrackedStatsChanged"
	CUtlVectorEmbeddedNetworkVar< TrackedStatNetworkData_t > m_vecTrackedStats;
};

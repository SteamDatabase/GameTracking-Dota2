// MNetworkVarNames = "uint32 m_FoWTempViewerVersion"
// MNetworkVarNames = "TempViewerInfo_t m_TempViewerInfo"
class CDOTAFogOfWarTempViewers : public CBaseEntity
{
	// MNetworkEnable
	uint32 m_FoWTempViewerVersion;
	// MNetworkEnable
	CUtlVectorEmbeddedNetworkVar< TempViewerInfo_t > m_TempViewerInfo;
	GameTime_t m_flEndTimeMin;
};

class CDOTAFogOfWarTempViewers : public CBaseEntity
{
	uint32 m_FoWTempViewerVersion;
	CUtlVectorEmbeddedNetworkVar< TempViewerInfo_t > m_TempViewerInfo;
	GameTime_t m_flEndTimeMin;
};

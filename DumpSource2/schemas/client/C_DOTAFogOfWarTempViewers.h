// MNetworkVarNames = "uint32 m_FoWTempViewerVersion"
// MNetworkVarNames = "TempViewerInfo_t m_TempViewerInfo"
class C_DOTAFogOfWarTempViewers : public C_BaseEntity
{
	// MNetworkEnable
	uint32 m_FoWTempViewerVersion;
	// MNetworkEnable
	C_UtlVectorEmbeddedNetworkVar< TempViewerInfo_t > m_TempViewerInfo;
	int32 m_dota_spectator_fog_of_war_last;
	uint32 m_unLastFogOfWarTeam;
};

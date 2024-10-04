class C_DOTAFogOfWarTempViewers : public C_BaseEntity
{
	uint32 m_FoWTempViewerVersion;
	C_UtlVectorEmbeddedNetworkVar< TempViewerInfo_t > m_TempViewerInfo;
	int32 m_dota_spectator_fog_of_war_last;
	uint32 m_unLastFogOfWarTeam;
}

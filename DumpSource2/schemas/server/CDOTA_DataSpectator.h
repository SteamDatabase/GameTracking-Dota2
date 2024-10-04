class CDOTA_DataSpectator : public CDOTA_DataNonSpectator
{
	CHandle< CBaseEntity > m_hPowerupRune_1;
	CHandle< CBaseEntity > m_hPowerupRune_2;
	CHandle< CBaseEntity > m_hBountyRune_1;
	CHandle< CBaseEntity > m_hBountyRune_2;
	CHandle< CBaseEntity > m_hBountyRune_3;
	CHandle< CBaseEntity > m_hBountyRune_4;
	CHandle< CBaseEntity > m_hXPRune_1;
	CHandle< CBaseEntity > m_hXPRune_2;
	int32[24] m_iNetWorth;
	float32 m_fRadiantWinProbability;
	CUtlVectorEmbeddedNetworkVar< DOTAThreatLevelInfo_t > m_ThreatLevelInfos;
};

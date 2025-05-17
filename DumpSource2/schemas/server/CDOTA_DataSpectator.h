// MNetworkVarNames = "CHandle< CBaseEntity> m_hPowerupRune_1"
// MNetworkVarNames = "CHandle< CBaseEntity> m_hPowerupRune_2"
// MNetworkVarNames = "CHandle< CBaseEntity> m_hBountyRune_1"
// MNetworkVarNames = "CHandle< CBaseEntity> m_hBountyRune_2"
// MNetworkVarNames = "CHandle< CBaseEntity> m_hBountyRune_3"
// MNetworkVarNames = "CHandle< CBaseEntity> m_hBountyRune_4"
// MNetworkVarNames = "CHandle< CBaseEntity> m_hXPRune_1"
// MNetworkVarNames = "CHandle< CBaseEntity> m_hXPRune_2"
// MNetworkVarNames = "int m_iNetWorth"
// MNetworkVarNames = "float m_fRadiantWinProbability"
// MNetworkVarNames = "DOTAThreatLevelInfo_t m_ThreatLevelInfos"
class CDOTA_DataSpectator : public CDOTA_DataNonSpectator
{
	// MNetworkEnable
	CHandle< CBaseEntity > m_hPowerupRune_1;
	// MNetworkEnable
	CHandle< CBaseEntity > m_hPowerupRune_2;
	// MNetworkEnable
	CHandle< CBaseEntity > m_hBountyRune_1;
	// MNetworkEnable
	CHandle< CBaseEntity > m_hBountyRune_2;
	// MNetworkEnable
	CHandle< CBaseEntity > m_hBountyRune_3;
	// MNetworkEnable
	CHandle< CBaseEntity > m_hBountyRune_4;
	// MNetworkEnable
	CHandle< CBaseEntity > m_hXPRune_1;
	// MNetworkEnable
	CHandle< CBaseEntity > m_hXPRune_2;
	// MNetworkEnable
	int32[24] m_iNetWorth;
	// MNetworkEnable
	float32 m_fRadiantWinProbability;
	// MNetworkEnable
	CUtlVectorEmbeddedNetworkVar< DOTAThreatLevelInfo_t > m_ThreatLevelInfos;
};

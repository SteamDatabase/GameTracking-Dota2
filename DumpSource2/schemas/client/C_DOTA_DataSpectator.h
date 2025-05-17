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
// MNetworkVarNames = "int m_iGoldSpentOnSupport"
// MNetworkVarNames = "int m_iHeroDamage"
// MNetworkVarNames = "int m_nWardsPurchased"
// MNetworkVarNames = "int m_nWardsPlaced"
// MNetworkVarNames = "int m_nWardsDestroyed"
// MNetworkVarNames = "int m_nRunesActivated"
// MNetworkVarNames = "int m_nCampsStacked"
// MNetworkVarNames = "DOTAThreatLevelInfo_t m_ThreatLevelInfos"
class C_DOTA_DataSpectator : public C_DOTA_DataNonSpectator
{
	// MNetworkEnable
	CHandle< C_BaseEntity > m_hPowerupRune_1;
	// MNetworkEnable
	CHandle< C_BaseEntity > m_hPowerupRune_2;
	// MNetworkEnable
	CHandle< C_BaseEntity > m_hBountyRune_1;
	// MNetworkEnable
	CHandle< C_BaseEntity > m_hBountyRune_2;
	// MNetworkEnable
	CHandle< C_BaseEntity > m_hBountyRune_3;
	// MNetworkEnable
	CHandle< C_BaseEntity > m_hBountyRune_4;
	// MNetworkEnable
	CHandle< C_BaseEntity > m_hXPRune_1;
	// MNetworkEnable
	CHandle< C_BaseEntity > m_hXPRune_2;
	// MNetworkEnable
	int32[24] m_iNetWorth;
	// MNetworkEnable
	float32 m_fRadiantWinProbability;
	// MNetworkEnable
	int32[24] m_iGoldSpentOnSupport;
	// MNetworkEnable
	int32[24] m_iHeroDamage;
	// MNetworkEnable
	int32[24] m_nWardsPurchased;
	// MNetworkEnable
	int32[24] m_nWardsPlaced;
	// MNetworkEnable
	int32[24] m_nWardsDestroyed;
	// MNetworkEnable
	int32[24] m_nRunesActivated;
	// MNetworkEnable
	int32[24] m_nCampsStacked;
	// MNetworkEnable
	C_UtlVectorEmbeddedNetworkVar< DOTAThreatLevelInfo_t > m_ThreatLevelInfos;
};

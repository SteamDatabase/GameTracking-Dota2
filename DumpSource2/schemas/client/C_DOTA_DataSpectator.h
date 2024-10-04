class C_DOTA_DataSpectator : public C_DOTA_DataNonSpectator
{
	CHandle< C_BaseEntity > m_hPowerupRune_1;
	CHandle< C_BaseEntity > m_hPowerupRune_2;
	CHandle< C_BaseEntity > m_hBountyRune_1;
	CHandle< C_BaseEntity > m_hBountyRune_2;
	CHandle< C_BaseEntity > m_hBountyRune_3;
	CHandle< C_BaseEntity > m_hBountyRune_4;
	CHandle< C_BaseEntity > m_hXPRune_1;
	CHandle< C_BaseEntity > m_hXPRune_2;
	int32[24] m_iNetWorth;
	float32 m_fRadiantWinProbability;
	int32[24] m_iGoldSpentOnSupport;
	int32[24] m_iHeroDamage;
	int32[24] m_nWardsPurchased;
	int32[24] m_nWardsPlaced;
	int32[24] m_nWardsDestroyed;
	int32[24] m_nRunesActivated;
	int32[24] m_nCampsStacked;
	C_UtlVectorEmbeddedNetworkVar< DOTAThreatLevelInfo_t > m_ThreatLevelInfos;
};

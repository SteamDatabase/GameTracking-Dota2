class PlayerResourcePlayerEventData_t
{
	uint32 m_iEventID;
	uint32 m_iEventLevel;
	uint32 m_iEventPoints;
	uint32 m_iEventPremiumPoints;
	uint32 m_iEventEffectsMask;
	bool m_bIsEventOwned;
	uint32 m_iFavoriteTeam;
	uint16 m_iFavoriteTeamQuality;
	uint8 m_iAvailableSalutes;
	uint8 m_iSaluteAmountIndex;
	uint32 m_iEventWagerStreak;
	uint8 m_iEventTeleportFXLevel;
	int32[5] m_nCandyPointsReason;
	C_UtlVectorEmbeddedNetworkVar< PlayerResourcePlayerPeriodicResourceData_t > m_vecPeriodicResources;
	uint8 m_iObsoleteSaluteAmounts;
	uint32 m_iObsoleteEventArcanaPeriodicResourceRemaining;
	uint32 m_iObsoleteEventArcanaPeriodicResourceMax;
	uint32 m_iObsoleteEventWagerTokensRemaining;
	uint32 m_iObsoleteEventWagerTokensMax;
	uint32 m_iObsoleteEventBountiesRemaining;
	uint32 m_iObsoleteRankWagersAvailable;
	uint32 m_iObsoleteRankWagersMax;
	uint32 m_iObsoleteEventPointAdjustmentsRemaining;
	uint16 m_iObsoleteEventRanks;
};

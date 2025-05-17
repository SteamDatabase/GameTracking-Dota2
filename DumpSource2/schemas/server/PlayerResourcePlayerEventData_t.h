// MNetworkVarNames = "uint32 m_iEventID"
// MNetworkVarNames = "uint32 m_iEventLevel"
// MNetworkVarNames = "uint32 m_iEventPoints"
// MNetworkVarNames = "uint32 m_iEventPremiumPoints"
// MNetworkVarNames = "uint32 m_iEventEffectsMask"
// MNetworkVarNames = "bool m_bIsEventOwned"
// MNetworkVarNames = "TeamID_t m_iFavoriteTeam"
// MNetworkVarNames = "uint16 m_iFavoriteTeamQuality"
// MNetworkVarNames = "uint8 m_iAvailableSalutes"
// MNetworkVarNames = "uint8 m_iSaluteAmountIndex"
// MNetworkVarNames = "uint32 m_iEventWagerStreak"
// MNetworkVarNames = "uint8 m_iEventTeleportFXLevel"
// MNetworkVarNames = "int m_nCandyPointsReason"
// MNetworkVarNames = "PlayerResourcePlayerPeriodicResourceData_t m_vecPeriodicResources"
// MNetworkVarNames = "uint8 m_iObsoleteSaluteAmounts"
// MNetworkVarNames = "uint32 m_iObsoleteEventArcanaPeriodicResourceRemaining"
// MNetworkVarNames = "uint32 m_iObsoleteEventArcanaPeriodicResourceMax"
// MNetworkVarNames = "uint32 m_iObsoleteEventWagerTokensRemaining"
// MNetworkVarNames = "uint32 m_iObsoleteEventWagerTokensMax"
// MNetworkVarNames = "uint32 m_iObsoleteEventBountiesRemaining"
// MNetworkVarNames = "uint32 m_iObsoleteRankWagersAvailable"
// MNetworkVarNames = "uint32 m_iObsoleteRankWagersMax"
// MNetworkVarNames = "uint32 m_iObsoleteEventPointAdjustmentsRemaining"
// MNetworkVarNames = "uint16 m_iObsoleteEventRanks"
class PlayerResourcePlayerEventData_t
{
	// MNetworkEnable
	uint32 m_iEventID;
	// MNetworkEnable
	uint32 m_iEventLevel;
	// MNetworkEnable
	uint32 m_iEventPoints;
	// MNetworkEnable
	uint32 m_iEventPremiumPoints;
	// MNetworkEnable
	uint32 m_iEventEffectsMask;
	// MNetworkEnable
	bool m_bIsEventOwned;
	// MNetworkEnable
	uint32 m_iFavoriteTeam;
	// MNetworkEnable
	uint16 m_iFavoriteTeamQuality;
	// MNetworkEnable
	uint8 m_iAvailableSalutes;
	// MNetworkEnable
	uint8 m_iSaluteAmountIndex;
	// MNetworkEnable
	uint32 m_iEventWagerStreak;
	// MNetworkEnable
	uint8 m_iEventTeleportFXLevel;
	// MNetworkEnable
	int32[5] m_nCandyPointsReason;
	// MNetworkEnable
	CUtlVectorEmbeddedNetworkVar< PlayerResourcePlayerPeriodicResourceData_t > m_vecPeriodicResources;
	// MNetworkEnable
	// MNetworkAlias = "m_iSaluteAmounts"
	uint8 m_iObsoleteSaluteAmounts;
	// MNetworkEnable
	// MNetworkAlias = "m_iEventArcanaPeriodicResourceRemaining"
	uint32 m_iObsoleteEventArcanaPeriodicResourceRemaining;
	// MNetworkEnable
	// MNetworkAlias = "m_iEventArcanaPeriodicResourceMax"
	uint32 m_iObsoleteEventArcanaPeriodicResourceMax;
	// MNetworkEnable
	// MNetworkAlias = "m_iEventWagerTokensRemaining"
	uint32 m_iObsoleteEventWagerTokensRemaining;
	// MNetworkEnable
	// MNetworkAlias = "m_iEventWagerTokensMax"
	uint32 m_iObsoleteEventWagerTokensMax;
	// MNetworkEnable
	// MNetworkAlias = "m_iEventBountiesRemaining"
	uint32 m_iObsoleteEventBountiesRemaining;
	// MNetworkEnable
	// MNetworkAlias = "m_iRankWagersAvailable"
	uint32 m_iObsoleteRankWagersAvailable;
	// MNetworkEnable
	// MNetworkAlias = "m_iRankWagersMax"
	uint32 m_iObsoleteRankWagersMax;
	// MNetworkEnable
	// MNetworkAlias = "m_iEventPointAdjustmentsRemaining"
	uint32 m_iObsoleteEventPointAdjustmentsRemaining;
	// MNetworkEnable
	// MNetworkAlias = "m_iEventRanks"
	uint16 m_iObsoleteEventRanks;
};

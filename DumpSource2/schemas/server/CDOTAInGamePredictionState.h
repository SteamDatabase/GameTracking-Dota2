// MNetworkVarNames = "bool m_bVotingClosed"
// MNetworkVarNames = "bool m_bAllPredictionsFinished"
// MNetworkVarNames = "InGamePredictionData_t m_vecPredictions"
// MNetworkVarNames = "LeagueID_t m_nLeagueID"
class CDOTAInGamePredictionState : public CBaseEntity
{
	// MNetworkEnable
	bool m_bVotingClosed;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnAllPredictionsFinished"
	bool m_bAllPredictionsFinished;
	// MNetworkEnable
	CUtlVectorEmbeddedNetworkVar< InGamePredictionData_t > m_vecPredictions;
	// MNetworkEnable
	LeagueID_t m_nLeagueID;
};

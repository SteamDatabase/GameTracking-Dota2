class CDOTAInGamePredictionState
{
	bool m_bVotingClosed;
	bool m_bAllPredictionsFinished;
	C_UtlVectorEmbeddedNetworkVar< InGamePredictionData_t > m_vecPredictions;
	LeagueID_t m_nLeagueID;
	CUtlVector< InGamePredictionData_t > m_vecPrevPredictions;
};

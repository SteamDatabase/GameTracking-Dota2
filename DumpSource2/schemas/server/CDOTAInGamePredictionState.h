class CDOTAInGamePredictionState : public CBaseEntity
{
	bool m_bVotingClosed;
	bool m_bAllPredictionsFinished;
	CUtlVectorEmbeddedNetworkVar< InGamePredictionData_t > m_vecPredictions;
	LeagueID_t m_nLeagueID;
};

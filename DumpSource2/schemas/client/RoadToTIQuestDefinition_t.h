class RoadToTIQuestDefinition_t
{
	RoadToTIQuestID_t m_unID;
	ERoadToTIQuestType m_eQuestType;
	uint32 m_unPeriod;
	MatchID_t m_unMatchID;
	uint32 m_unSeriesID;
	uint32 m_unLeagueID;
	uint32 m_unPlayerID;
	uint32 m_unTeamID;
	CUtlVector< HeroID_t > m_vecHeroes;
	bool m_bDeveloper;
}

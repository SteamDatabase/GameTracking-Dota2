class FantasyLeagueData_t
{
	FantasyLeagueID_t m_nFantasyLeagueID;
	EEvent m_eEvent;
	FantasyCraftDataID_t m_nCraftingID;
	CUtlVector< LeagueID_t > m_nLeagues;
	CUtlVector< FantasyRoleData_t > m_vecPlayers;
	CUtlVector< FantasyPeriodData_t > m_vecPeriods;
}

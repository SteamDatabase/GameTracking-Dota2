// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MPropertyAutoExpandSelf
class FantasyLeagueData_t
{
	// MPropertyDescription = "Unique identifier for the league"
	FantasyLeagueID_t m_nFantasyLeagueID;
	// MPropertyDescription = "What event this data is tied to"
	EEvent m_eEvent;
	// MPropertyDescription = "What data to use for crafting"
	FantasyCraftDataID_t m_nCraftingID;
	// MPropertyDescription = "Which Leagues is this attached to"
	CUtlVector< LeagueID_t > m_nLeagues;
	CUtlVector< FantasyRoleData_t > m_vecPlayers;
	CUtlVector< FantasyPeriodData_t > m_vecPeriods;
};

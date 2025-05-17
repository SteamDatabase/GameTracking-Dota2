// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MVDataRoot
class CDOTABingoGameDefinition
{
	EEvent m_eEvent;
	LeagueID_t m_unLeagueID;
	int32 m_nShuffleCardCost;
	int32 m_nRerollSquareCost;
	int32 m_nUpgradeSquareCost;
	int32 m_nMaxSquareUpgrades;
	CUtlVector< float32 > m_vecExpectedMatchCountsPerPhase;
	CUtlVector< uint32 > m_vecLeaguePhases;
	CUtlVector< CUtlVector< int32 > > m_vecValidStatRangesPerPhase;
	CUtlOrderedMap< CUtlString, CDOTABingoStatDefinition > m_mapBingoStatsByName;
};

// MGetKV3ClassDefaults = {
//	"m_eEvent": 1610725832,
//	"m_unLeagueID": 0,
//	"m_nShuffleCardCost": 1,
//	"m_nRerollSquareCost": 1,
//	"m_nUpgradeSquareCost": 1,
//	"m_nMaxSquareUpgrades": 1,
//	"m_vecExpectedMatchCountsPerPhase":
//	[
//	],
//	"m_vecLeaguePhases":
//	[
//	],
//	"m_vecValidStatRangesPerPhase":
//	[
//	],
//	"m_mapBingoStatsByName":
//	{
//	}
//}
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

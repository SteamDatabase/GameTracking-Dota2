// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MVDataRoot
class CDOTABingoStatDefinition
{
	// MPropertyDescription = "Stats that share the same exclusive group cannot be generated in the same card."
	CUtlString m_strExclusiveString;
	// MPropertyDescription = "Expected value (for a match)."
	float32 m_fStatAverage;
	// MPropertyDescription = "Statistical standard deviation (for a match)."
	float32 m_fStatStdDev;
	// MPropertyDescription = "Optional Hero Adjective, used to populate heroes in a bingo stat tooltip"
	CUtlString m_strHeroAdjective;
	// MPropertyDescription = "Whether we negate the hero adjective when displaying tooltip"
	bool m_bNegativeHeroAdjective;
	// MPropertyDescription = "At which league phase this stat unlocks"
	int32 m_nMinLeaguePhase;
	// MPropertyDescription = "Up to which league phase this stat is usable"
	int32 m_nMaxLeaguePhase;
	// MPropertyDescription = "Expected value for League Phase Playoffs game."
	float32 m_fPlayoffsStatAverage;
	// MPropertyDescription = "Statistical standard deviation of League Phase Playoffs game."
	float32 m_fPlayoffsStatStdDev;
	// MPropertyDescription = "Expected value for League Phase Main Event game."
	float32 m_fMainEventStatAverage;
	// MPropertyDescription = "Statistical standard deviation of League Phase Main Event game."
	float32 m_fMainEventStatStdDev;
	CUtlString m_sLocName;
	CUtlString m_sLocTooltip;
};

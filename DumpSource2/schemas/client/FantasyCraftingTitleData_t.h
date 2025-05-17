// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MPropertyAutoExpandSelf
class FantasyCraftingTitleData_t
{
	// MPropertyDescription = "Unique integer ID of the title"
	FantasyTitle_t m_unTitle;
	// MPropertyDescription = "Localization name of the title when used as an aggregate"
	CUtlString m_sLocName;
	// MPropertyDescription = "Localization name of the title when used on it's own"
	CUtlString m_sLocNameIndividual;
	// MPropertyDescription = "Localization token for explaining what the title does"
	CUtlString m_sLocExplanation;
	// MPropertyDescription = "Localization token for explaining what the title does in sitations that allow mouseover"
	CUtlString m_sLocExplanationMouseOver;
	// MPropertyDescription = "Controls how we decide to use the stat vector"
	EFantasyStatMatchMode m_eMode;
	// MPropertyDescription = "Stats to Track"
	CUtlVector< FantasyCraftingTrackedStat_t > m_vecStats;
	// MPropertyDescription = "Bonus this title provides"
	int32 m_nBonus;
};

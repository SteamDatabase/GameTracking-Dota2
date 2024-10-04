class FantasyCraftingTitleData_t
{
	FantasyTitle_t m_unTitle;
	CUtlString m_sLocName;
	CUtlString m_sLocNameIndividual;
	CUtlString m_sLocExplanation;
	CUtlString m_sLocExplanationMouseOver;
	EFantasyStatMatchMode m_eMode;
	CUtlVector< FantasyCraftingTrackedStat_t > m_vecStats;
	int32 m_nBonus;
};

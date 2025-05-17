// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MPropertyAutoExpandSelf
class CDOTABattleReportHighlightTier_t
{
	// MPropertyDescription = "Tier of the Reward"
	CMsgBattleReport_HighlightTier m_eTier;
	// MPropertyDescription = "Compare Contexts to Achieve Tier"
	// MPropertyAutoExpandSelf
	CUtlVector< CDOTABattleReportHighlightCompareContext_t > m_vecCompareContexts;
};

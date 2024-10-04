class CDOTABattleReportHighlight
{
	uint16 m_nID;
	bool m_bEnabled;
	CMsgBattleReport_HighlightType m_eHighlightType;
	CMsgBattleReport_HighlightCategory m_eHighlightCategory;
	CMsgBattleReport_HighlightRarity m_eHighlightRarity;
	CUtlString m_sNameToken;
	CUtlString m_sFlavorToken;
	bool m_bTooltip;
	CUtlString m_sTooltipLocString;
	EHighlightNumberFormat m_eFormat;
	CUtlVector< CMsgBattleReport_Role > m_vecRoles;
	CUtlVector< CDOTABattleReportHighlightTier_t > m_vecTiers;
}

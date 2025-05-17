// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MVDataRoot
class CDOTABattleReportHighlight
{
	// MPropertyDescription = "Battle Report Highlight ID"
	// MVDataUniqueMonotonicInt = "_editor/next_battle_report_highlight_id"
	// MPropertyAttributeEditor = "locked_int()"
	uint16 m_nID;
	// MPropertyDescription = "Enabled"
	bool m_bEnabled;
	// MPropertyDescription = "Battle Report Highlight Type"
	// MPropertyFriendlyName = "Gameplay Outcome to Highlight"
	CMsgBattleReport_HighlightType m_eHighlightType;
	// MPropertyDescription = "Battle Report Highlight Category"
	CMsgBattleReport_HighlightCategory m_eHighlightCategory;
	// MPropertyDescription = "Battle Report Highlight Rarity"
	CMsgBattleReport_HighlightRarity m_eHighlightRarity;
	// MPropertyDescription = "Localized name for this highlight"
	CUtlString m_sNameToken;
	// MPropertyDescription = "Localized name for this highlight"
	CUtlString m_sFlavorToken;
	// MPropertyDescription = "Helper Tooltip Available"
	bool m_bTooltip;
	// MPropertyDescription = "Helper Tooltip Loc String"
	// MPropertySuppressExpr = "m_bTooltip == false"
	CUtlString m_sTooltipLocString;
	// MPropertyDescription = "Number formatting for player score"
	EHighlightNumberFormat m_eFormat;
	// MPropertyDescription = "Roles for the Highlight.  If none selected, use all roles."
	// MPropertySuppressExpr = "m_eHighlightCategory != k_eHighlightRole"
	CUtlVector< CMsgBattleReport_Role > m_vecRoles;
	// MPropertyDescription = "Possible Tiers for the Highlight"
	// MPropertyAutoExpandSelf
	CUtlVector< CDOTABattleReportHighlightTier_t > m_vecTiers;
};

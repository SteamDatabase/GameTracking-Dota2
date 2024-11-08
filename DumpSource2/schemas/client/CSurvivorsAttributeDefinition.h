class CSurvivorsAttributeDefinition
{
	CUtlString m_sLocName;
	CUtlString m_sLocTooltip;
	CUtlString m_sLocDescription;
	CUtlString m_sLocMetaUpgradesTooltip;
	CPanoramaImageName m_sImage;
	bool m_bPrimary;
	bool m_bPercentage;
	bool m_bShouldUpgradeProgressionText;
	CUtlVector< CSurvivorsAttributeDefinition::MetaProgressionTier_t > m_vecMetaProgressionTiers;
};

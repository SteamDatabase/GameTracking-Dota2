// MGetKV3ClassDefaults = {
//	"m_sLocName": "",
//	"m_sLocTooltip": "",
//	"m_sLocDescription": "",
//	"m_sLocMetaUpgradesTooltip": "",
//	"m_sImage": "",
//	"m_bPrimary": false,
//	"m_bPercentage": false,
//	"m_bShouldUpgradeProgressionText": true,
//	"m_vecMetaProgressionTiers":
//	[
//	]
//}
// MVDataRoot
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

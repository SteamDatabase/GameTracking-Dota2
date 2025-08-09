// MGetKV3ClassDefaults = {
//	"m_unQualityID": 0,
//	"m_sLocName": "",
//	"m_nBonus": 0,
//	"m_nRollWeight": 0
//}
// MPropertyAutoExpandSelf
class FantasyCraftingQualityData_t
{
	// MPropertyDescription = "Unique Identifier for the Quality"
	FantasyGemQuality_t m_unQualityID;
	// MPropertyDescription = "Localization token for the name of the quality"
	CUtlString m_sLocName;
	// MPropertyDescription = "How much does this quality improve the stat?"
	int32 m_nBonus;
	// MPropertyDescription = "How likely are we to roll this quality?"
	int32 m_nRollWeight;
};

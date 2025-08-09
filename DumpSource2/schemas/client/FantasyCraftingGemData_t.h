// MGetKV3ClassDefaults = {
//	"m_eType": "FANTASY_GEM_TYPE_RUBY",
//	"m_sLocName": "",
//	"m_eStats":
//	[
//	]
//}
// MPropertyAutoExpandSelf
class FantasyCraftingGemData_t
{
	// MPropertyDescription = "Unique Identifier for the Gem Type"
	Fantasy_Gem_Type m_eType;
	// MPropertyDescription = "Localization name of the gem"
	CUtlString m_sLocName;
	// MPropertyDescription = "Which stats can this gem roll"
	CUtlVector< Fantasy_Scoring > m_eStats;
};

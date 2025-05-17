// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
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

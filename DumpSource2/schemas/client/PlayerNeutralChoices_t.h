// MNetworkVarNames = "AbilityID_t m_vecTrinketChoices"
// MNetworkVarNames = "AbilityID_t m_vecEnhancementChoices"
// MNetworkVarNames = "int m_vecSelectedTrinkets"
// MNetworkVarNames = "int m_vecSelectedEnhancements"
// MNetworkVarNames = "int m_vecTimesCrafted"
class PlayerNeutralChoices_t
{
	// MNetworkEnable
	AbilityID_t[25] m_vecTrinketChoices;
	// MNetworkEnable
	AbilityID_t[25] m_vecEnhancementChoices;
	// MNetworkEnable
	int32[5] m_vecSelectedTrinkets;
	// MNetworkEnable
	int32[5] m_vecSelectedEnhancements;
	// MNetworkEnable
	int32[5] m_vecTimesCrafted;
};

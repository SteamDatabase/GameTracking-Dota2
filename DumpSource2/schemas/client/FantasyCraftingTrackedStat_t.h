// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MPropertyAutoExpandSelf
class FantasyCraftingTrackedStat_t
{
	// MPropertyDescription = "What Stats are we looking for"
	CUtlString m_sStatName;
	// MPropertyDescription = "Is the match about the player, the player's team, or the match?"
	EFantasyStatType m_eStatType;
	// MPropertyDescription = "Threshold Stat Value required"
	uint32 m_unThresholdValue;
	// MPropertyDescription = "Is the treshold a min or max?"
	bool m_bThresholdIsMin;
};

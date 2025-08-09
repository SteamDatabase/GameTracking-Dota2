// MGetKV3ClassDefaults = {
//	"m_sStatName": "",
//	"m_eStatType": "k_eFantasyStatType_Player",
//	"m_unThresholdValue": 0,
//	"m_bThresholdIsMin": true
//}
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

// MGetKV3ClassDefaults = {
//	"m_unQuestID": 0,
//	"m_type": "k_eCraftworksQuest_Invalid",
//	"m_strLocName": "",
//	"m_strLocProgress": "",
//	"m_flTurboMultiplier": 1.000000,
//	"m_vecRewards":
//	[
//	],
//	"m_strTrackedStatName": "",
//	"m_unStatMaximum": 0,
//	"m_bShowInGameProgressToasts": false
//}
class CCraftworksQuestDefinition
{
	CraftworksQuestID_t m_unQuestID;
	CraftworksQuestType_t m_type;
	CUtlString m_strLocName;
	CUtlString m_strLocProgress;
	float32 m_flTurboMultiplier;
	CUtlVector< CCraftworksQuestComponentReward > m_vecRewards;
	CUtlString m_strTrackedStatName;
	uint32 m_unStatMaximum;
	bool m_bShowInGameProgressToasts;
};

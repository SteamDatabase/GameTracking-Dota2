// MGetKV3ClassDefaults = {
//	"m_unRecipeID": 0,
//	"m_unRecipeTierID": 0,
//	"m_strLocName": "",
//	"m_strRewardAction": "",
//	"m_bSeasonalReward": false,
//	"m_vecComponents":
//	[
//	]
//}
class CCraftworksRecipeDefinition
{
	CraftworksRecipeID_t m_unRecipeID;
	CraftworksRecipeTierID_t m_unRecipeTierID;
	CUtlString m_strLocName;
	CUtlString m_strRewardAction;
	bool m_bSeasonalReward;
	CUtlVector< CCraftworksRecipeComponentQuantity > m_vecComponents;
};

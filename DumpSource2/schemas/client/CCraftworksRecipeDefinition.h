class CCraftworksRecipeDefinition
{
	CraftworksRecipeID_t m_unRecipeID;
	CraftworksRecipeTierID_t m_unRecipeTierID;
	CUtlString m_strLocName;
	CUtlString m_strRewardAction;
	bool m_bSeasonalReward;
	CUtlVector< CCraftworksRecipeComponentQuantity > m_vecComponents;
};

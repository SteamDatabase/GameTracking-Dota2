class CavernCrawlReward_t
{
	uint32 m_nActionID;
	CUtlString m_rewardName;
	CavernCrawlItemType_t m_nItemType;
	CUtlString m_locString;
	CUtlString m_tooltipString;
	CUtlString m_image;
	CavernCrawlRewardType_t m_nStyleUnlockRewardType;
	uint8 m_nPriority;
	style_index_t m_nBundleItemDefStyle;
	bool m_bImageIsBundleItemDef;
	bool m_bCannotBeReplacedWithUltraRareReward;
	bool m_bIsUltraRareReward;
}

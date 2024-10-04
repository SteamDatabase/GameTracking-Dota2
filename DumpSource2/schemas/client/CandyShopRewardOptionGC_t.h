class CandyShopRewardOptionGC_t
{
	CandyShopRewardOptionID_t m_unRewardOptionID;
	uint32 m_unRewardOptionMaxCount;
	uint32 m_unCandyPrice;
	uint32 m_unWeight;
	ECandyShopRewardOptionType m_eOptionType;
	item_definition_index_t m_unSingleItemDef;
	CUtlString m_sLootList;
	EEvent m_eEvent;
	uint32 m_unEventActionID;
	uint32 m_unEventPoints;
};

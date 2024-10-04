class CDOTACandyShopDefinition
{
	CandyShopID_t m_unCandyShopID;
	CUtlString m_sLocName;
	uint32 m_unDefaultInventorySize;
	uint32 m_unMaximumInventorySize;
	uint32 m_unDefaultRerollCharges;
	uint32 m_unDefaultMaxRerollCharges;
	item_definition_index_t m_unCandyBagItemDef;
	uint8 m_unFixedExchangeRecipeMaxCandies;
	uint32 m_unFixedExchangeRecipeStartDate;
	uint32 m_unFixedExchangeRecipeUpdateRateInSeconds;
	uint8 m_unFixedExchangeRecipeDefaultCount;
	uint8 m_unFixedExchangeRecipeMaximumCount;
	uint8 m_unVariableExchangeInputCandyCount;
	uint8 m_unVariableExchangeOutputCandyCount;
	EEvent m_eExpireEvent;
	uint8 m_unRewardSlotsDefaultCount;
	CUtlString m_sAttrLootList;
	CUtlString m_sViewPageEvent;
	CUtlVector< CandyShopCandyType_t > m_vecCandyTypes;
	CUtlVector< CandyShopRewardSlot_t > m_vecRewardSlots;
	CUtlVector< CandyShopRewardOption_t > m_vecDefaultRewardOptions;
};

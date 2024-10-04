class C_EconItemView : public IEconItemInterface
{
	item_definition_index_t m_iItemDefinitionIndex;
	int32 m_iEntityQuality;
	uint32 m_iEntityLevel;
	itemid_t m_iItemID;
	uint32 m_iAccountID;
	uint32 m_iInventoryPosition;
	bool m_bInitialized;
	style_index_t m_nOverrideStyle;
	bool m_bIsStoreItem;
	bool m_bIsTradeItem;
	bool m_bHasComputedAttachedParticles;
	bool m_bHasAttachedParticles;
	int32 m_iEntityQuantity;
	uint8 m_unClientFlags;
	eEconItemOrigin m_unOverrideOrigin;
	CAttributeList m_AttributeList;
};

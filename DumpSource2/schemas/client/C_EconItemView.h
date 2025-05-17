// MNetworkVarNames = "item_definition_index_t m_iItemDefinitionIndex"
// MNetworkVarNames = "int m_iEntityQuality"
// MNetworkVarNames = "uint32 m_iEntityLevel"
// MNetworkVarNames = "itemid_t m_iItemID"
// MNetworkVarNames = "uint32 m_iAccountID"
// MNetworkVarNames = "uint32 m_iInventoryPosition"
// MNetworkVarNames = "bool m_bInitialized"
// MNetworkVarNames = "style_index_t m_nOverrideStyle"
// MNetworkVarNames = "CAttributeList m_AttributeList"
class C_EconItemView : public IEconItemInterface
{
	// MNetworkEnable
	item_definition_index_t m_iItemDefinitionIndex;
	// MNetworkEnable
	int32 m_iEntityQuality;
	// MNetworkEnable
	uint32 m_iEntityLevel;
	// MNetworkEnable
	itemid_t m_iItemID;
	// MNetworkEnable
	uint32 m_iAccountID;
	// MNetworkEnable
	uint32 m_iInventoryPosition;
	// MNetworkEnable
	bool m_bInitialized;
	// MNetworkEnable
	style_index_t m_nOverrideStyle;
	bool m_bIsStoreItem;
	bool m_bIsTradeItem;
	bool m_bHasComputedAttachedParticles;
	bool m_bHasAttachedParticles;
	int32 m_iEntityQuantity;
	uint8 m_unClientFlags;
	eEconItemOrigin m_unOverrideOrigin;
	// MNetworkEnable
	CAttributeList m_AttributeList;
};

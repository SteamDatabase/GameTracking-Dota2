// MNetworkVarNames = "QuickBuySlot_t m_vecItemSlots"
// MNetworkVarNames = "int m_nTotalSlotCountIncludingOverflow"
class InventoryQuickBuyState_t
{
	// MNetworkEnable
	C_UtlVectorEmbeddedNetworkVar< QuickBuySlot_t > m_vecItemSlots;
	// MNetworkEnable
	int32 m_nTotalSlotCountIncludingOverflow;
	QuickBuySlot_t m_stickyItemSlot;
	int32 m_nPrevPurchasable;
};

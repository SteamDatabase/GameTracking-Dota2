// MNetworkVarNames = "AbilityID_t m_nAbilityID"
// MNetworkVarNames = "int m_nTopLevelItem"
// MNetworkVarNames = "AbilityID_t m_nTopLevelItemAbilityID"
// MNetworkVarNames = "QuickBuyPurchasable_t m_ePurchasableState"
// MNetworkVarNames = "QuickBuyPurchasable_t m_ePurchasableAccumState"
// MNetworkVarNames = "bool m_bMarkedForBuy"
// MNetworkVarNames = "int m_nParity"
class QuickBuySlot_t
{
	// MNetworkEnable
	AbilityID_t m_nAbilityID;
	// MNetworkEnable
	int32 m_nTopLevelItem;
	// MNetworkEnable
	AbilityID_t m_nTopLevelItemAbilityID;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnQuickBuySlotPurchasableChanged"
	QuickBuyPurchasable_t m_ePurchasableState;
	// MNetworkEnable
	QuickBuyPurchasable_t m_ePurchasableAccumState;
	// MNetworkEnable
	bool m_bMarkedForBuy;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnQuickBuySlotParityChanged"
	int32 m_nParity;
	bool m_bSticky;
	QuickBuyPurchasable_t m_ePrevPurchasableState;
	bool m_bNewlyActionable;
	bool m_bPurchaseInFlight;
};

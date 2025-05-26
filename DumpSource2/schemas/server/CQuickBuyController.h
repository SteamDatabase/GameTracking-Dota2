// MNetworkVarNames = "PlayerID_t m_nPlayerID"
// MNetworkVarNames = "InventoryQuickBuyState_t m_quickBuyState"
// MNetworkVarNames = "bool m_bBuybackProtectionEnabled"
// MNetworkVarNames = "bool m_bAutoMarkForBuy"
// MNetworkVarNames = "EHANDLE m_vecControlledUnits"
class CQuickBuyController
{
	// MNetworkEnable
	// MNetworkChangeCallback = "OnPlayerIDUpdated"
	PlayerID_t m_nPlayerID;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnQuickBuyItemsChanged"
	InventoryQuickBuyState_t m_quickBuyState;
	// MNetworkEnable
	bool m_bBuybackProtectionEnabled;
	// MNetworkEnable
	bool m_bAutoMarkForBuy;
	// MNetworkEnable
	CNetworkUtlVectorBase< CHandle< CBaseEntity > > m_vecControlledUnits;
	int32 m_nNextOrder;
	bool m_bQuickBuyIgnoredStateDirty;
	int32 m_nSuggestItemIdx;
};

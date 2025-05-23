// MNetworkVarNames = "bool m_bAutoCourierAutoBurst"
// MNetworkVarNames = "bool m_bAutoCourierAutoDeliver"
// MNetworkVarNames = "bool m_bDeliverWhileVisibleOnly"
// MNetworkVarNames = "DOTACourierHandle_t m_hCourier"
// MNetworkVarNames = "PlayerID_t m_nPlayerID"
// MNetworkVarNames = "bool m_bUseNewLogic"
// MNetworkVarNames = "DOTA_SHOP_TYPE m_eFSMShop"
// MNetworkVarNames = "EHANDLE m_hFSMUnit"
// MNetworkVarNames = "ECourierState m_eFSMState"
// MNetworkVarNames = "bool m_bFSMTransferAfter"
// MNetworkVarNames = "bool m_bFSMStashAfter"
// MNetworkVarNames = "bool m_bManualRequest"
class CDOTACourierController
{
	// MNetworkEnable
	bool m_bAutoCourierAutoBurst;
	// MNetworkEnable
	bool m_bAutoCourierAutoDeliver;
	// MNetworkEnable
	bool m_bDeliverWhileVisibleOnly;
	// MNetworkEnable
	CHandle< C_DOTA_Unit_Courier > m_hCourier;
	// MNetworkEnable
	PlayerID_t m_nPlayerID;
	// MNetworkEnable
	bool m_bUseNewLogic;
	// MNetworkEnable
	DOTA_SHOP_TYPE m_eFSMShop;
	// MNetworkEnable
	CHandle< C_BaseEntity > m_hFSMUnit;
	// MNetworkEnable
	ECourierState m_eFSMState;
	// MNetworkEnable
	bool m_bFSMTransferAfter;
	// MNetworkEnable
	bool m_bFSMStashAfter;
	// MNetworkEnable
	bool m_bManualRequest;
};

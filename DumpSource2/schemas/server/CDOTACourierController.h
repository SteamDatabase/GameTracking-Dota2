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
	CHandle< CDOTA_Unit_Courier > m_hCourier;
	// MNetworkEnable
	PlayerID_t m_nPlayerID;
	// MNetworkEnable
	bool m_bUseNewLogic;
	// MNetworkEnable
	DOTA_SHOP_TYPE m_eFSMShop;
	// MNetworkEnable
	CHandle< CBaseEntity > m_hFSMUnit;
	// MNetworkEnable
	ECourierState m_eFSMState;
	// MNetworkEnable
	bool m_bFSMTransferAfter;
	// MNetworkEnable
	bool m_bFSMStashAfter;
	// MNetworkEnable
	bool m_bManualRequest;
	bool m_bIgnoreNextPlayerInteraction;
	bool m_bWasAlive;
	bool m_bOwnerWasAlive;
	CountdownTimer m_TransitionTimer;
	CountdownTimer m_ManualTimer;
	float32 m_flCourier_wait_time_item_purchase;
	float32 m_flCourier_wait_time_item_mark;
	float32 m_flCourier_wait_time_manualorder;
	float32 m_flCourier_wait_time_manualorder_stop;
	float32 m_flCourier_nondivert_range;
	float32 m_flCourier_min_dot_for_divert;
	float32 m_flCourier_max_divert_length;
	float32 m_flCourier_max_divert_mult;
	float32 m_flCourier_divert_near_shop_dist;
	CUtlVector< bool > m_vecAutoState;
	int32 m_nLastSecondCaptured;
};

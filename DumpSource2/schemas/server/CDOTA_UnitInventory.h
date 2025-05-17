// MNetworkExcludeByName = "m_hInventoryParent"
// MNetworkVarNames = "EHANDLE m_hItems"
// MNetworkVarNames = "int m_iParity"
// MNetworkVarNames = "EHANDLE m_hInventoryParent"
// MNetworkVarNames = "bool m_bStashEnabled"
// MNetworkVarNames = "EHANDLE m_hTransientCastItem"
class CDOTA_UnitInventory
{
	CUtlVector< sSharedCooldownInfo > m_SharedCooldownList;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnInventoryChanged"
	CNetworkUtlVectorBase< CHandle< CBaseEntity > > m_hItems;
	bool[27] m_bItemQueried;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnInventoryParityChanged"
	int32 m_iParity;
	// MNetworkEnable
	CHandle< CBaseEntity > m_hInventoryParent;
	bool m_bIsActive;
	// MNetworkEnable
	bool m_bStashEnabled;
	// MNetworkEnable
	CHandle< CBaseEntity > m_hTransientCastItem;
};

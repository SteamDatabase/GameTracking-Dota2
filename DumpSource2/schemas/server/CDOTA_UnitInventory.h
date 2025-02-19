class CDOTA_UnitInventory
{
	CUtlVector< sSharedCooldownInfo > m_SharedCooldownList;
	CNetworkUtlVectorBase< CHandle< CBaseEntity > > m_hItems;
	bool[27] m_bItemQueried;
	int32 m_iParity;
	CHandle< CBaseEntity > m_hInventoryParent;
	bool m_bIsActive;
	bool m_bStashEnabled;
	CHandle< CBaseEntity > m_hTransientCastItem;
};

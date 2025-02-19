class C_DOTA_UnitInventory
{
	CUtlVector< sSharedCooldownInfo > m_SharedCooldownList;
	C_NetworkUtlVectorBase< CHandle< C_BaseEntity > > m_hItems;
	bool[27] m_bItemQueried;
	int32 m_iParity;
	CHandle< C_BaseEntity > m_hInventoryParent;
	bool m_bIsActive;
	bool m_bStashEnabled;
	CHandle< C_BaseEntity > m_hTransientCastItem;
	bool m_bSendChangedMsg;
	int32 m_nAcknowledgedParity;
};

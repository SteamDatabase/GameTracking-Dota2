class CDOTA_UnitInventory
{
	CUtlVector< sSharedCooldownInfo > m_SharedCooldownList;
	CHandle< CBaseEntity >[19] m_hItems;
	bool[21] m_bItemQueried;
	int32 m_iParity;
	CHandle< CBaseEntity > m_hInventoryParent;
	bool m_bIsActive;
	bool m_bStashEnabled;
	CHandle< CBaseEntity > m_hTransientCastItem;
};

// MNetworkVarNames = "CHandle<CDOTA_Item> m_hItem"
// MNetworkVarNames = "bool m_bIsLowPriorityHoverItem"
class CDOTA_Item_Physical : public CBaseAnimatingActivity
{
	int32 m_nFlags;
	int32 m_nRevealedInFoWForTeam;
	GameTime_t m_fCreationTime;
	// MNetworkEnable
	CHandle< CDOTA_Item > m_hItem;
	// MNetworkEnable
	bool m_bIsLowPriorityHoverItem;
};

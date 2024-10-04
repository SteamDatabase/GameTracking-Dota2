class CDOTA_Item_Physical : public CBaseAnimatingActivity
{
	int32 m_nFlags;
	int32 m_nRevealedInFoWForTeam;
	GameTime_t m_fCreationTime;
	CHandle< CDOTA_Item > m_hItem;
	bool m_bIsLowPriorityHoverItem;
}

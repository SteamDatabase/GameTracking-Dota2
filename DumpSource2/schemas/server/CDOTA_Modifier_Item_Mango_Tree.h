class CDOTA_Modifier_Item_Mango_Tree : public CDOTA_Buff_Item
{
	CHandle< CBaseEntity > m_hTree;
	CountdownTimer m_Timer;
	float32 seconds;
};

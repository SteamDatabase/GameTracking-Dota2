class CDOTA_Modifier_Passive_Mango_Tree : public CDOTA_Buff
{
	CHandle< C_BaseEntity > m_hTree;
	int32 m_nMangoSeconds;
	CountdownTimer m_MangoTimer;
	int32 m_nRespawnSeconds;
	CountdownTimer m_RespawnTimer;
	int32 m_nMangosAvailable;
	int32 m_nChannelCount;
};

class CDOTA_Modifier_Watcher_State : public CDOTA_Buff
{
	int32 m_nOwningTeamNumber;
	bool m_bHasSentFirstReady;
	GameTime_t m_flNextReadyTime;
	uint32 m_uFoWVisibilityMask;
};

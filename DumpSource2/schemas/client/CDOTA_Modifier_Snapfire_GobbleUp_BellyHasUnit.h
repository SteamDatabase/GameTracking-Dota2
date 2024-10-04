class CDOTA_Modifier_Snapfire_GobbleUp_BellyHasUnit : public CDOTA_Buff
{
	CHandle< C_BaseEntity > m_hGobbledUnit;
	PlayerID_t m_nOriginalControllingUnit;
	bool m_bUnitWasLaunched;
	float32 max_time_in_belly;
}

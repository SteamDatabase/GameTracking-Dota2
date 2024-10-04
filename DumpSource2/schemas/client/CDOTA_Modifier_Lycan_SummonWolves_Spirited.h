class CDOTA_Modifier_Lycan_SummonWolves_Spirited : public CDOTA_Buff
{
	CHandle< C_BaseEntity > m_hOwner;
	int32 wolf_index;
	int32 back_distance;
	int32 side_distance;
	Vector m_vecDesiredPosition;
	int32 m_iBackOffsetFactor;
	bool m_bRightWolf;
	float32 invis_level;
	int32 model_scale;
	bool m_bInitialized;
	bool m_bDeathFxTriggered;
	float32 death_fx_time;
}

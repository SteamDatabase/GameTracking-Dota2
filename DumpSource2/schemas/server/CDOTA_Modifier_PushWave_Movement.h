class CDOTA_Modifier_PushWave_Movement : public CDOTA_Buff
{
	CHandle< CBaseEntity > m_hWave;
	Vector m_vDirection;
	int32 wave_movespeed;
};

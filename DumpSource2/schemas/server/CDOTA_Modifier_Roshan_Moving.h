class CDOTA_Modifier_Roshan_Moving : public CDOTA_Buff
{
	int32 movement_speed;
	CHandle< CBaseEntity > m_hTarget;
	bool m_bFlipped;
};

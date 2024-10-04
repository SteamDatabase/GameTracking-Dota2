class CDOTA_Modifier_Wind_Waker : public CDOTA_Buff
{
	CHandle< CBaseEntity > m_hBlocker;
	GameTime_t m_flStartTime;
	Vector m_vStartPos;
	float32 m_flCurTime;
	float32 m_flHeightT;
	Vector m_vMoveToPos;
};

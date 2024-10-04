class CDOTA_Modifier_JungleVarmint_Dive : public CDOTA_Buff
{
	float32 m_flTotalTime;
	float32 m_flInitialVelocity;
	Vector m_vStartPosition;
	Vector m_vTargetHorizontalDirection;
	float32 m_flCurrentTimeHoriz;
	float32 m_flCurrentTimeVert;
	bool m_bInterrupted;
	int32 distance;
	float32 speed;
	float32 acceleration;
	int32 radius;
}

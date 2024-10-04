class CDOTA_Modifier_Jakiro_DualBreath_Thinker : public CDOTA_Buff
{
	float32 start_radius;
	float32 end_radius;
	GameTime_t m_fStartTime;
	float32 m_fTotalTime;
	Vector m_vCastPosition;
};

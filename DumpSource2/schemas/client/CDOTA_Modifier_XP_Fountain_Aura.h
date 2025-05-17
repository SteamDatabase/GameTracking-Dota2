class CDOTA_Modifier_XP_Fountain_Aura : public CDOTA_Buff
{
	bool m_bActive;
	bool m_bIsGranting;
	bool m_bInitialized;
	bool m_bSetFoW;
	GameTime_t m_flNextXpActivationTime;
	float32 countdown_time;
	float32 think_interval;
	float32 m_flRemainingCountDownTime;
	float32 radius;
};

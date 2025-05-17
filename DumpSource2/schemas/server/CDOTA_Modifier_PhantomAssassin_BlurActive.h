class CDOTA_Modifier_PhantomAssassin_BlurActive : public CDOTA_Buff
{
	int32 radius;
	float32 fade_duration;
	int32 break_on_attack;
	bool m_bDestroyNext;
	int32 manacost_reduction_during_blur_pct;
	CHandle< CBaseEntity > m_hVisibleEntity;
	float32 m_flCountdown;
	float32 buff_duration_after_break;
	int32 active_movespeed_bonus;
	GameTime_t m_rtLastTime;
};

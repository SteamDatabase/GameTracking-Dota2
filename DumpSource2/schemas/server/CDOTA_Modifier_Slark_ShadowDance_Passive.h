class CDOTA_Modifier_Slark_ShadowDance_Passive
{
	float32 activation_delay;
	float32 neutral_disable;
	float32 linger_search_radius;
	float32 linger_duration;
	bool m_bPendingRefresh;
	GameTime_t m_fPendingStateChangeTime;
	CountdownTimer m_NeutralHitTimer;
};

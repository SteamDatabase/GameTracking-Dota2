class CDOTA_Modifier_Roshan_Moving
{
	int32 move_pits_bonus_speed_per_interrupt;
	int32 move_pits_max_bonus_speed;
	int32 move_pits_slow_resistance;
	bool m_bReachedMidpoint;
	int32 m_nInterruptCount;
	float32 m_flGrabAttemptTime;
	GameTime_t m_flLastInterrupted;
};

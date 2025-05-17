class CDOTA_Modifier_Nian_Leap : public CDOTA_Buff
{
	float32 m_flTotalTimeInAir;
	float32 m_flInitialVelocity;
	Vector m_vStartPosition;
	Vector m_vTargetHorizontalDirection;
	Vector m_vTargetPosition;
	float32 m_flCurrentTimeHoriz;
	float32 m_flCurrentTimeVert;
	bool m_bInterrupted;
	float32 m_flHorizDelayTime;
	float32 m_flVertDelayTime;
	float32 m_flLeapSequenceDuration;
	float32 m_flPlaybackRate;
	int32 pounce_distance;
	float32 pounce_speed;
	float32 pounce_acceleration;
	float32 initial_delay;
	float32 landing_delay;
};

class CDOTA_Modifier_OgreSealTotem_Active
{
	float32 m_flTotalTime;
	float32 m_flInitialVelocity;
	Vector m_vStartPosition;
	Vector m_vTargetHorizontalDirection;
	float32 m_flCurrentTimeHoriz;
	float32 m_flCurrentTimeVert;
	bool m_bInterrupted;
	Vector m_vLastOrderPos;
	bool m_bIssuedOrder;
	int32 m_nCurrentBounce;
	int32 leap_distance;
	float32 leap_speed;
	float32 leap_acceleration;
	int32 leap_radius;
	float32 leap_bonus_duration;
	bool m_bLaunched;
	float32 m_flFacingTarget;
	float32 movement_turn_rate;
};

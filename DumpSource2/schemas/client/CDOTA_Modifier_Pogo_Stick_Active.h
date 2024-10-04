class CDOTA_Modifier_Pogo_Stick_Active : public CDOTA_Buff
{
	int32 leap_distance;
	float32 leap_speed;
	float32 leap_acceleration;
	int32 leap_radius;
	float32 leap_bonus_duration;
	bool m_bLaunched;
};

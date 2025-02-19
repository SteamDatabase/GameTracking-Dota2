class CDOTA_Modifier_Slark_Pounce
{
	float32 m_flTotalTime;
	float32 m_flInitialVelocity;
	Vector m_vStartPosition;
	Vector m_vTargetHorizontalDirection;
	float32 m_flCurrentTimeHoriz;
	float32 m_flCurrentTimeVert;
	bool m_bInterrupted;
	bool m_bFoundUnit;
	int32 pounce_distance;
	int32 pounce_distance_scepter;
	float32 pounce_speed;
	float32 pounce_acceleration;
	int32 pounce_radius;
	int32 pounce_damage;
	float32 leash_duration;
};

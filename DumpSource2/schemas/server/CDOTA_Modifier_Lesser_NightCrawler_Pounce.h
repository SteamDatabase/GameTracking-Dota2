class CDOTA_Modifier_Lesser_NightCrawler_Pounce : public CDOTA_Buff
{
	float32 m_flTotalTime;
	float32 m_flInitialVelocity;
	Vector m_vStartPosition;
	Vector m_vTargetHorizontalDirection;
	float32 m_flCurrentTimeHoriz;
	float32 m_flCurrentTimeVert;
	bool m_bInterrupted;
	int32 pounce_distance;
	float32 pounce_speed;
	float32 pounce_acceleration;
	int32 pounce_radius;
	int32 pounce_damage;
	float32 leash_duration;
};

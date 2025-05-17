class CDOTA_Modifier_DarkSeer_Surge : public CDOTA_Buff
{
	int32 speed_boost;
	float32 trail_radius;
	float32 trail_duration;
	Vector m_vLastTrailThinkerLocation;
	bool m_bTrailStarted;
};

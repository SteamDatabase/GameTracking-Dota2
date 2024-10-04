class CDOTA_Modifier_Mirana_Leap : public CDOTA_Buff
{
	int32 leap_distance;
	float32 shard_radius;
	float32 shard_radius_end;
	float32 shard_damage;
	float32 shard_slow_pct;
	float32 shard_slow_duration;
	float32 leap_speed;
	float32 leap_acceleration;
	int32 leap_radius;
	float32 leap_bonus_duration;
	bool m_bLaunched;
};

class CDOTA_Modifier_Dawnbreaker_Celestial_Hammer_Movement
{
	int32 m_nProjectileID;
	int32 projectile_speed;
	int32 travel_speed_pct;
	int32 m_nMaxRange;
	Vector m_vStartPoint;
	Vector m_vLastTrailThinkerLocation;
	Vector m_vEndPointShard;
	ParticleIndex_t m_nStatusFXIndex;
	int32 flare_radius;
	bool bHasStartedBurning;
	float32 flare_debuff_duration;
	float32 fire_trail_health_regen;
};

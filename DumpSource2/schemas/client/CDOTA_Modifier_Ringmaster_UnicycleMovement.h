class CDOTA_Modifier_Ringmaster_UnicycleMovement : public CDOTA_Buff
{
	float32 max_speed;
	float32 acceleration;
	float32 turn_rate_min;
	float32 turn_rate_max;
	float32 impact_radius;
	float32 tree_impact_speed_divisor;
	float32 knockback_distance;
	float32 damage_threshold;
	float32 damage_grace_period;
	float32 m_flCurrentSpeed;
	float32 m_bCrashScheduled;
	float32 m_flDesiredYaw;
	ParticleIndex_t m_nMaxSpeedFXIndex;
};

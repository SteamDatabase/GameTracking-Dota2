class CDOTA_Modifier_Nian_Dive
{
	int32 pounce_distance;
	float32 pounce_speed;
	float32 pounce_acceleration;
	int32 pounce_radius;
	int32 pounce_damage;
	int32 stun_radius;
	float32 stun_duration;
	float32 leash_duration;
	float32 initial_delay;
	float32 landing_delay;
	float32 vertical_adjust;
	float32 vertical_adjust_max_distance;
	float32 vertical_adjust_min_distance;
	int32 claw_damage;
	int32 claw_damage_radius;
	float32 claw_damage_delay;
	float32 claw_damage_duration;
	CUtlVector< CHandle< C_BaseEntity > > m_vHitEntities;
};

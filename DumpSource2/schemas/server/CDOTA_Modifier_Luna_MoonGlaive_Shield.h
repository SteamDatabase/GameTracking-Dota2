class CDOTA_Modifier_Luna_MoonGlaive_Shield : public CDOTA_Buff
{
	int32 rotating_glaives;
	float32 rotating_glaives_hit_radius;
	float32 rotating_glaives_speed;
	float32 rotating_glaives_collision_damage;
	float32 rotating_glaives_movement_radius;
	float32 rotating_glaives_damage_reduction;
	int32 unclamp_max_radius;
	float32 rotating_glaives_duration;
	float32 m_flCurRotation;
	float32 m_flCurRadius;
	float32 m_flCurRadiusUnclamped;
	float32 m_flSecondsPerRotation;
	float32 m_flMaxRadius;
	GameTime_t m_flStartTime;
};

class CDOTA_Modifier_Ringmaster_Spotlight_Thinker : public CDOTA_Buff
{
	bool self_spotlight;
	float32 radius;
	float32 initial_speed;
	float32 sweep_speed;
	float32 sweep_radius;
	float32 linger_duration;
	Vector m_vStartLocation;
	Vector m_vTargetLocation;
	float32 m_flTargetReachedTime;
}

class CDOTA_Modifier_Ringmaster_Wheel_Mesmerize : public CDOTA_Buff
{
	float32 wheel_stun;
	float32 mesmerize_radius;
	float32 vision_cone;
	float32 explosion_damage;
	CountdownTimer m_ctFuseTimer;
	ParticleIndex_t m_nFXIndex;
	int32 m_nTimesTriggered;
}

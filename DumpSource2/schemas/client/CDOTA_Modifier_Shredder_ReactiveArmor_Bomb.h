class CDOTA_Modifier_Shredder_ReactiveArmor_Bomb
{
	float32 initial_shield;
	float32 max_shield;
	float32 shield_per_sec;
	float32 shield_per_sec_per_enemy;
	float32 duration;
	float32 base_explosion;
	int32 radius;
	int32 explosion_radius;
	int32 m_nDamageAbsorbed;
	GameTime_t m_timeLastTick;
	GameTime_t m_StartTime;
	int32 m_nLastParticleTime;
};

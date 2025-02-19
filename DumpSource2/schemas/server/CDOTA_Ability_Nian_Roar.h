class CDOTA_Ability_Nian_Roar
{
	int32 base_projectiles;
	int32 max_projectiles;
	int32 projectile_step;
	int32 base_speed;
	int32 speed_step;
	int32 initial_radius;
	int32 end_radius;
	int32 damage;
	float32 base_interval;
	float32 interval_step;
	int32 m_nCastCount;
	int32 m_nProjectiles;
	int32 m_nWaveCount;
	CountdownTimer m_ctTimer;
	float32 m_flTiming;
	bool m_bScriptRoar;
};

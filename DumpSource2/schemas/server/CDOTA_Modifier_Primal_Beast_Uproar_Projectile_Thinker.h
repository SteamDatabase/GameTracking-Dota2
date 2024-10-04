class CDOTA_Modifier_Primal_Beast_Uproar_Projectile_Thinker : public CDOTA_Buff
{
	int32 projectiles_per_stack;
	int32 projectile_speed;
	float32 projectile_distance;
	float32 projectile_width;
	int32 splinter_angle;
	float32 split_delay;
	int32 projectile_waves;
	int32 m_nCurrentWaveCount;
	int32 tectonic_shift_projectiles;
	CUtlVector< CHandle< CBaseEntity > > m_vecEnemiesHit;
	CUtlVector< int32 > m_vecProjectileHandles;
}

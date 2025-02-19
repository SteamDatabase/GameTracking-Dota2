class CDOTA_Modifier_CrystalMaiden_FreezingField
{
	float32 radius;
	int32 damage;
	int32 bonus_armor;
	float32 explosion_interval;
	float32 shard_bonus_explosion;
	float32 explosion_radius;
	float32 slow_duration;
	int32 explosion_min_dist;
	float32 explosion_max_dist;
	float32 frostbite_delay;
	GameTime_t m_fLastTick;
	float32 m_fTimeAccumulator;
	int32 m_iExplosionCount;
	int32 m_iExplosionTotalCount;
	int32 m_iExplosionQuadrant;
	int32 m_iExplosionDistance;
	int32 shard_self_movement_speed_slow_pct;
	ParticleIndex_t m_nFXIndex;
	CUtlVector< CHandle< C_BaseEntity > > m_hHitEntities;
	int32 can_move;
};

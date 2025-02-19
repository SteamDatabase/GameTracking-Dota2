class CDOTA_Modifier_PrimalBeast_Onslaught_Movement
{
	float32 tick_interval;
	float32 charge_speed;
	float32 movement_turn_rate;
	float32 knockback_radius;
	float32 knockback_distance;
	int32 knockback_damage;
	int32 m_nEnemyHeroesHit;
	float32 m_flFacingTarget;
	ParticleIndex_t m_nFXIndex;
	CUtlVector< CHandle< CBaseEntity > > m_hHitEntities;
};

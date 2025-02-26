class CDOTA_Modifier_Pangolier_Gyroshell
{
	int32 mp_cost_per_second;
	float32 tick_interval;
	float32 forward_move_speed;
	float32 turn_rate_boosted;
	float32 turn_rate;
	float32 hit_radius;
	float32 knockback_radius;
	int32 damage_pct;
	bool m_bHitFirstUpdate;
	GameTime_t m_flHitEndTime;
	float32 hit_recover_time;
	GameTime_t m_flJumpEndTime;
	float32 jump_recover_time;
	float32 m_flTurnBoostProgress;
	float32 m_flFacingTarget;
	bool m_bIsJumping;
	ParticleIndex_t m_nFXIndex;
	CUtlVector< float32 > m_flTurnHistory;
	CUtlVector< CHandle< CBaseEntity > > m_vecHeroesHitLastRicochet;
	CUtlVector< CHandle< CBaseEntity > > m_vecHeroesCredited;
	CUtlVector< CHandle< CBaseEntity > > m_vecHeroesHitCurrentRicochet;
};

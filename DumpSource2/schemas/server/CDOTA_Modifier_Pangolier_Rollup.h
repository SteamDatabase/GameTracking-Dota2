class CDOTA_Modifier_Pangolier_Rollup : public CDOTA_Modifier_DebuffImmune
{
	int32 mp_cost_per_second;
	float32 tick_interval;
	float32 forward_move_speed;
	float32 turn_rate_boosted;
	float32 turn_rate;
	int32 hit_radius;
	int32 knockback_radius;
	bool m_bHitFirstUpdate;
	GameTime_t m_flHitEndTime;
	float32 hit_recover_time;
	GameTime_t m_flJumpEndTime;
	float32 jump_recover_time;
	float32 m_flTurnBoostProgress;
	float32 m_flFacingTarget;
	GameTime_t m_flLastHeroAttackTime;
	bool m_bIsJumping;
	ParticleIndex_t m_nFXIndex;
	float32 m_flGyroshellDurationRemaining;
	CUtlVector< float32 > m_flTurnHistory;
	CUtlVector< CHandle< CBaseEntity > > m_vecHeroesHitLastRicochet;
	CUtlVector< CHandle< CBaseEntity > > m_vecHeroesCredited;
	CUtlVector< CHandle< CBaseEntity > > m_vecHeroesHitCurrentRicochet;
}

class CDOTA_Modifier_Miniboss_Minion_Deflecting_Shield_Buff : public CDOTA_Buff
{
	float32 max_barrier_pct_max_health;
	float32 owner_max_barrier_pct_max_health;
	float32 regeneration_to_max_seconds;
	float32 decay_to_zero_seconds;
	float32 damage_reflection_pct;
	float32 damage_cooldown;
	float32 aura_radius;
	float32 m_flMaxBarrier;
	float32 m_flBarrierAmount;
	GameTime_t m_timeLastTick;
	GameTime_t m_timeLastDamage;
};

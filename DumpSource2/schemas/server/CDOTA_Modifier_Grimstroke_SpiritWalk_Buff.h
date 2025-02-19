class CDOTA_Modifier_Grimstroke_SpiritWalk_Buff
{
	GameTime_t m_fStartTime;
	int32 m_nHeroTickDamageApplied;
	GameTime_t m_fLastEffectsTime;
	int32 radius;
	float32 buff_duration;
	float32 debuff_duration;
	int32 max_damage;
	float32 max_stun;
	int32 movespeed_bonus_pct;
	int32 damage_per_tick;
	float32 tick_rate;
	float32 max_threshold_duration;
	int32 can_end_early;
	int32 shard_bonus_damage_pct;
	int32 shard_heal_pct;
	float32 shard_creep_penalty;
	bool m_bIsReflection;
};

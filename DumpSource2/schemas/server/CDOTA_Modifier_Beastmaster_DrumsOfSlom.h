class CDOTA_Modifier_Beastmaster_DrumsOfSlom
{
	float32 aura_radius;
	int32 radius;
	int32 max_stacks;
	float32 base_damage;
	int32 heal_pct;
	int32 creep_heal_pct;
	int32 iCurrentAttacksAtMinInterval;
	float32 stack_decay_time;
	float32 max_drum_hit_interval;
	float32 min_drum_hit_interval;
	GameTime_t m_flLastStackChangeTime;
	GameTime_t m_flLastDrumHitTime;
};

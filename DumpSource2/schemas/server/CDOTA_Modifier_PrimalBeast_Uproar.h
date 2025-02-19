class CDOTA_Modifier_PrimalBeast_Uproar
{
	int32 stack_limit;
	int32 damage_limit;
	int32 stack_count_increase_on_disable;
	float32 stack_duration;
	float32 damage_min;
	float32 damage_max;
	int32 bonus_damage_per_stack;
	ParticleIndex_t m_nFxIndexA;
	int32 iCur_stack;
	float32 slow_duration;
	float32 m_fTotalDamage;
	GameTime_t m_flLastStackTime;
};

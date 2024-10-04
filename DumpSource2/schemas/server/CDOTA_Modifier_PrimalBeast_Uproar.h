class CDOTA_Modifier_PrimalBeast_Uproar : public CDOTA_Modifier_Stacking_Base
{
	int32 stack_limit;
	int32 damage_limit;
	float32 stack_duration;
	float32 damage_min;
	float32 damage_max;
	int32 bonus_damage_per_stack;
	ParticleIndex_t m_nFxIndexA;
	int32 iCur_stack;
	int32 bonus_damage;
	float32 slow_duration;
	float32 m_fTotalDamage;
	GameTime_t m_flLastStackTime;
}

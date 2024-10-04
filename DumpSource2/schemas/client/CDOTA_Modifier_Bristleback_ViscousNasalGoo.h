class CDOTA_Modifier_Bristleback_ViscousNasalGoo : public CDOTA_Buff
{
	float32 base_armor;
	float32 armor_per_stack;
	int32 base_move_slow;
	int32 move_slow_per_stack;
	int32 stack_limit;
	ParticleIndex_t m_nFXStackIndex;
};

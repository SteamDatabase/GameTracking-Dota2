class CDOTA_Modifier_Visage_Lurker : public CDOTA_Buff
{
	int32 max_stacks;
	float32 stack_gain_time;
	float32 cooldown_speed_per_stack;
	float32 linger_duration;
	ParticleIndex_t m_nFXIndex;
};

class CDOTA_Modifier_Juggernaut_Bladeform : public CDOTA_Buff
{
	int32 max_stacks;
	float32 stack_gain_time;
	float32 agi_bonus_pct_per_stack;
	float32 movement_speed_pct_per_stack;
	float32 linger_duration;
	ParticleIndex_t m_nFXIndex;
};

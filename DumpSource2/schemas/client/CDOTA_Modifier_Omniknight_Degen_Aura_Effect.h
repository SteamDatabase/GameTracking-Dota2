class CDOTA_Modifier_Omniknight_Degen_Aura_Effect : public CDOTA_Buff
{
	int32 speed_bonus;
	int32 bonus_damage_per_stack;
	float32 stack_interval;
	float32 linger_duration;
	int32 max_stacks;
	bool m_bActive;
	GameTime_t m_flLastActiveTime;
};

class CDOTA_Modifier_Bristleback_Warpath : public CDOTA_Buff
{
	int32 damage_per_stack;
	float32 move_speed_per_stack;
	int32 max_stacks;
	float32 stack_duration;
	int32 aspd_per_stack;
	float32 active_bonus_attack_percent;
	float32 active_bonus_movement_percent;
	GameTime_t m_flMaxStackStartTime;
	bool m_bSuppressKillEater;
};

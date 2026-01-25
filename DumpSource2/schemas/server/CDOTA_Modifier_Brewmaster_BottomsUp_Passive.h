class CDOTA_Modifier_Brewmaster_BottomsUp_Passive : public CDOTA_Buff
{
	int32 brewed_up_per_ability;
	int32 brewed_up_per_proc;
	int32 brewed_up_max_stack;
	float32 max_hp_regen;
	float32 brewed_up_min_speed;
	float32 brewed_up_max_speed;
	float32 speed_toggle_time;
	float32 stack_duration;
	bool m_bMinimumSpeed;
	GameTime_t m_SpeedToggleTime;
	int32 m_nMaxHPRegen;
	int32 m_nCurrentSpeed;
	ParticleIndex_t m_nFXIndex;
	ParticleIndex_t m_nFXIndexB;
};

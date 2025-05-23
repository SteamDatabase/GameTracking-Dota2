class CDOTA_Modifier_Invoker_IceWall_SlowDebuff : public CDOTA_Buff
{
	int32 slow;
	float32 damage_per_second;
	int32 vector_cast_range;
	float32 root_delay;
	float32 root_duration;
	float32 root_damage;
	float32 tick_interval;
	CHandle< C_BaseEntity > m_hThinker;
	GameTime_t m_NextDPSTime;
	GameTime_t m_NextRootTime;
	bool m_bRootTriggered;
};

class CDOTA_Modifier_Largo_Frogstomp_Thinker : public CDOTA_Buff
{
	float32 damage_per_stomp;
	int32 total_ticks;
	float32 radius;
	float32 stun_duration;
	float32 stomp_interval;
	float32 delay;
	bool m_bStarted;
};

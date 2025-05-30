class CDOTA_Modifier_SandKing_Epicenter : public CDOTA_Buff
{
	float32 epicenter_radius_base;
	float32 epicenter_radius_increment;
	int32 epicenter_pulses;
	float32[30] epicenter_radius;
	int32 m_iMaxPulses;
	int32 m_iPulseCount;
	float32 m_flPulseTickRate;
	float32 spine_tick_rate;
	GameTime_t m_flLastDamageTime;
	GameTime_t m_flLastSpineTime;
};

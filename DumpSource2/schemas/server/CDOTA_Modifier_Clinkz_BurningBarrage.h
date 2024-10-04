class CDOTA_Modifier_Clinkz_BurningBarrage : public CDOTA_Buff
{
	int32 m_iArrowCount;
	Vector m_vOriginalTarget;
	int32 arrow_width;
	float32 arrow_speed;
	float32 arrow_range_multiplier;
	int32 wave_count;
	int32 arrow_count_per_wave;
	int32 arrow_angle;
	int32 m_iLoopCount;
	float32 m_flInterval;
	float32 m_flCycleDelay;
	float32 m_flTimeWaste;
	GameTime_t m_flExpectedTime;
};

class CDOTA_Modifier_Seasonal_TI11_CongaLine
{
	int32 NUM_SOUNDS;
	float32 dance_interval;
	float32 gesture_duration;
	float32 catch_up_distance;
	float32 slow_duration;
	float32 slow_amount;
	int32 m_nGesture;
	CUtlVector< CHandle< CDOTA_BaseNPC > > m_vecDancers;
	bool m_bIsGesturing;
};

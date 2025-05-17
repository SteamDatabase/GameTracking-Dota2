class CDOTA_Modifier_Elder_Titan_EarthSplitter_Caster : public CDOTA_Buff
{
	CUtlVector< CHandle< C_BaseEntity > > m_hHitUnits;
	float32 vision_width;
	float32 vision_interval;
	float32 vision_duration;
	int32 vision_step;
	int32 total_steps;
	int32 m_nCompletedSteps;
	Vector m_vStart;
	Vector m_vEnd;
	Vector m_vNextVisionLocation;
	Vector m_vCastDirection;
};

class CDOTA_Modifier_Kez_FalconRush : public CDOTA_Buff
{
	int32 slow_resist;
	float32 rush_speed;
	float32 rush_range;
	float32 break_range;
	bool m_bInRush;
	ParticleIndex_t m_nFXIndex;
	CHandle< C_BaseEntity > m_hTarget;
};

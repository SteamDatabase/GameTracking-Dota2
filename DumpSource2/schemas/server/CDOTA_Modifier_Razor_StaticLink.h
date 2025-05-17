class CDOTA_Modifier_Razor_StaticLink : public CDOTA_Buff
{
	float32 flSmoothness;
	float32 drain_duration;
	int32 drain_rate;
	int32 drain_range;
	int32 drain_range_buffer;
	CHandle< CBaseEntity > m_hTarget;
	int32 m_iTotalDrainAmount;
	int32 pull_speed;
	int32 min_pull_range;
	ParticleIndex_t m_iLinkIndex;
	CDOTA_Buff* m_pBuffPositive;
	CDOTA_Buff* m_pNegative;
	GameTime_t m_flLastThinkTime;
};

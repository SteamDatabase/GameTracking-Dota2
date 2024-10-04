class CDOTA_Modifier_Dawnbreaker_BreakOfDawn : public CDOTA_Buff
{
	float32 reveal_duration;
	float32 conceal_duration;
	float32 think_interval;
	float32 reveal_linger;
	float32 reveal_radius;
	float32 m_flBonusVisionRadius;
	GameTime_t m_flRevealExpansionTime;
	GameTime_t m_flFullRevealLinger;
	GameTime_t m_flConcealTime;
	bool m_bWasDayTime;
}

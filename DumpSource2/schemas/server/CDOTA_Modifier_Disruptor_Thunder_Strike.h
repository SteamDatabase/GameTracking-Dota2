class CDOTA_Modifier_Disruptor_Thunder_Strike : public CDOTA_Buff
{
	float32 strike_interval;
	float32 radius;
	int32 strike_damage;
	int32 strike_damage_bonus;
	int32 hits_units_inside_kinetic;
	GameTime_t m_flGroundDelayEndTime;
	bool is_thinker;
	bool m_bTransferred;
	int32 m_nThinkerViewer;
	int32 m_nThinkerViewerTeam;
	int32 m_nStrikeCount;
}

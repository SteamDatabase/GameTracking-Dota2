class CDOTA_Modifier_ArcWarden_Flux : public CDOTA_Buff
{
	int32 m_nCasterTeam;
	float32 damage_per_second;
	int32 search_radius;
	int32 move_speed_slow_pct;
	int32 status_resist;
	float32 think_interval;
	int32 applies_silence;
	int32 m_nCurrentMovementSlow;
	int32 m_nCurrentStatusResistance;
	ParticleIndex_t m_nFXIndex;
};

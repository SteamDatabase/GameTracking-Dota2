class CDOTA_Modifier_Oracle_Prognosticate : public CDOTA_Buff
{
	int32 current_rune_location;
	int32 next_rune_location;
	int32 current_rune_type;
	int32 next_rune_type;
	bool started_spawning;
	float32 next_rune_spawn_time;
	bool m_bIsActive;
};

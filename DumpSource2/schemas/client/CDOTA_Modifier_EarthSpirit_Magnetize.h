class CDOTA_Modifier_EarthSpirit_Magnetize : public CDOTA_Buff
{
	int32 rock_search_radius;
	float32 damage_per_second;
	float32 damage_interval;
	float32 rock_explosion_delay;
	float32 damage_duration;
	int32 cast_radius;
	int32 rock_explosion_radius;
	bool magnetized_rocks_buff_self;
	int32 magnetized_rocks_buff_self_duration;
	CUtlVector< CHandle< C_BaseEntity > > m_hExplodedRocks;
	float32 duration;
	bool m_bShowOverhead;
}

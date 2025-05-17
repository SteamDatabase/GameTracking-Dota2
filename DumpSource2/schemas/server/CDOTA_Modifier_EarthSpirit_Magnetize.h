class CDOTA_Modifier_EarthSpirit_Magnetize : public CDOTA_Buff
{
	float32 rock_search_radius;
	float32 damage_per_second;
	float32 damage_interval;
	float32 rock_explosion_delay;
	float32 damage_duration;
	float32 cast_radius;
	float32 rock_explosion_radius;
	bool magnetized_rocks_buff_self;
	int32 magnetized_rocks_buff_self_duration;
	CUtlVector< CHandle< CBaseEntity > > m_hExplodedRocks;
	float32 duration;
	bool m_bShowOverhead;
};

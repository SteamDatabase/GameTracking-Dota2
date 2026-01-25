class CDOTA_Modifier_PhantomLancer_PhantomEdge_Boost : public CDOTA_Buff
{
	int32 bonus_speed;
	float32 agility_duration;
	bool m_bGiveAgility;
	CHandle< C_BaseEntity > m_hTarget;
	int32 bonus_agility;
	float32 illusion_spawn_radius;
	float32 illusion_spawn_travel_distance;
	float32 evasion;
	float32 m_flDistanceAccumulator;
	Vector m_vPreviousLocation;
};

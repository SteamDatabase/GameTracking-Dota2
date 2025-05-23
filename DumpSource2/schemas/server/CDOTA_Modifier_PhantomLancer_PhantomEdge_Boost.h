class CDOTA_Modifier_PhantomLancer_PhantomEdge_Boost : public CDOTA_Buff
{
	int32 bonus_speed;
	float32 agility_duration;
	bool m_bGiveAgility;
	CHandle< CBaseEntity > m_hTarget;
	int32 bonus_agility;
	float32 illusion_spawn_radius;
	CUtlVector< CHandle< CBaseEntity > > m_hHitEntities;
};

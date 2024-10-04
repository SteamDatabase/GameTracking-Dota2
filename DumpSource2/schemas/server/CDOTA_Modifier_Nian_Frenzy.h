class CDOTA_Modifier_Nian_Frenzy : public CDOTA_Buff
{
	int32 damage;
	int32 damage_radius;
	int32 stun_radius;
	float32 dive_distance;
	float32 initial_rise_time;
	float32 right_swipe_time;
	float32 left_swipe_time;
	float32 knockdown_duration;
	float32 stun_duration;
	int32 m_nTickCounter;
	CUtlVector< CHandle< CBaseEntity > > m_hEnemies;
};

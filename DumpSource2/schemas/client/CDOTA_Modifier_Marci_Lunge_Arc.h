class CDOTA_Modifier_Marci_Lunge_Arc
{
	bool m_bTriggeredLandingAnim;
	int32 m_nMaxJumpDistance;
	int32 min_jump_distance;
	int32 max_jump_distance;
	float32 min_lob_travel_time;
	float32 max_lob_travel_time;
	float32 landing_radius;
	float32 debuff_duration;
	float32 min_height_above_lowest;
	float32 min_height_above_highest;
	float32 min_acceleration;
	float32 max_acceleration;
	float32 impact_damage;
	int32 impact_position_offset;
	int32 ally_impact_damage_pct;
	float32 ally_buff_duration;
	CHandle< C_BaseEntity > m_hBounceEntity;
};

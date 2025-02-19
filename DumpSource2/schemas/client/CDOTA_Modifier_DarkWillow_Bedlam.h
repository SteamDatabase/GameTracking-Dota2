class CDOTA_Modifier_DarkWillow_Bedlam
{
	float32 m_flRotation;
	CHandle< C_BaseEntity > m_hWisp;
	GameTime_t m_flLastAttack;
	int32 roaming_radius;
	int32 attack_radius;
	float32 roaming_seconds_per_rotation;
	float32 attack_interval;
	int32 target_count;
	bool m_bTravelling;
	int32 travel_speed;
	int32 damage_reduction_pct;
};

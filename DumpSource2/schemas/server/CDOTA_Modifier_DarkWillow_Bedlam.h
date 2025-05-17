class CDOTA_Modifier_DarkWillow_Bedlam : public CDOTA_Buff
{
	float32 m_flRotation;
	CHandle< CBaseEntity > m_hWisp;
	GameTime_t m_flLastAttack;
	float32 roaming_radius;
	float32 attack_radius;
	float32 roaming_seconds_per_rotation;
	float32 attack_interval;
	int32 target_count;
	bool m_bTravelling;
	float32 travel_speed;
	int32 damage_reduction_pct;
};

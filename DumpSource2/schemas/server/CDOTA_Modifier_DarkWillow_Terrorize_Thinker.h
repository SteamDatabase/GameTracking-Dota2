class CDOTA_Modifier_DarkWillow_Terrorize_Thinker : public CDOTA_Buff
{
	CHandle< CBaseEntity > m_hWisp;
	float32 destination_travel_speed;
	float32 return_travel_speed;
	float32 destination_radius;
	float32 impact_damage;
	float32 destination_status_duration;
	float32 initial_delay;
	float32 starting_height;
	Vector m_vAttackLocation;
	bool m_bAttacking;
	bool m_bReturning;
	float32 m_fCurHeight;
	float32 m_fEstimatedTravelTime;
	float32 think_interval;
	bool m_bInFlight;
};

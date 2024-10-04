class CDOTA_Modifier_SpiritBreaker_ChargeOfDarkness : public CDOTA_Buff
{
	float32 movement_speed;
	int32 min_movespeed_bonus_pct;
	float32 out_of_world_time;
	float32 linger_time_min;
	float32 linger_time_max;
	float32 charge_for_max_linger;
	float32 windup_time;
	float32 m_flCurrentMovespeedBonus;
	CHandle< C_BaseEntity > m_hTarget;
	bool m_bGestureStarted;
}

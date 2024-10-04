class CDOTA_Modifier_PrimalBeast_Onslaught_Windup : public CDOTA_Buff
{
	bool m_bReachedMax;
	bool m_bShouldCharge;
	float32 m_flLastOverheadTime;
	float32 m_flFacingTarget;
	Vector m_vAimTarget;
	ParticleIndex_t m_nCrosshairFX;
	float32 m_flChargeDuration;
	int32 max_distance;
	float32 max_charge_time;
	float32 turn_rate;
	float32 base_power;
	int32 charge_speed;
}

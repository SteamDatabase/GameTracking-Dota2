class CDOTA_Modifier_EmberSpirit_FlameGuard : public CDOTA_Buff
{
	int32 absorb_amount;
	int32 damage_per_second;
	int32 radius;
	float32 tick_interval;
	int32 shield_pct_absorb;
	int32 m_nAbsorbRemaining;
	float32 m_flShowParticleInterval;
	bool m_bDestroy;
	float32 linger_duration;
};

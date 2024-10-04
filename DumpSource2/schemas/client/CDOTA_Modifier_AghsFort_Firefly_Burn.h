class CDOTA_Modifier_AghsFort_Firefly_Burn : public CDOTA_Buff
{
	int32 damage_pct_per_second;
	int32 movement_speed;
	float32 tick_interval;
	GameTime_t m_fNextDamageTick;
};

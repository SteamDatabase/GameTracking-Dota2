class CDOTA_Modifier_ShadowShaman_Shackles : public CDOTA_Buff
{
	ParticleIndex_t nShackleFXIndex;
	float32 tick_interval;
	float32 total_damage;
	float32 channel_time;
	float32 heal_percentage;
	bool bApplyHeal;
	float32 scepter_shock_pct;
	float32 scepter_shock_radius;
	float32 scepter_shock_interval;
	float32 ally_break_range;
	GameTime_t m_flNextShockTime;
};

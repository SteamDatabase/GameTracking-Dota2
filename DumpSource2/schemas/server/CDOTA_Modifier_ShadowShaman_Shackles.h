class CDOTA_Modifier_ShadowShaman_Shackles : public CDOTA_Buff
{
	ParticleIndex_t nShackleFXIndex;
	float32 tick_interval;
	float32 total_damage;
	float32 channel_time;
	float32 heal_percentage;
	bool bApplyHeal;
}

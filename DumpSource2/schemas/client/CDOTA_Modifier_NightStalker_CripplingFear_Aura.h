class CDOTA_Modifier_NightStalker_CripplingFear_Aura : public CDOTA_Buff
{
	float32 radius;
	int32 death_refresh;
	float32 mana_pct_cost;
	float32 mana_interval;
	ParticleIndex_t m_nFXIndex;
	float32 base_duration;
	GameTime_t m_flStartTime;
};

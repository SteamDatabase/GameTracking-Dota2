class CDOTA_Modifier_Dawnbreaker_Solar_Guardian_Thinker : public CDOTA_Buff
{
	GameTime_t flTimeSinceLastPulse;
	float32 pulse_interval;
	float32 flEffectRadius;
	int32 base_damage;
	int32 base_heal;
	int32 effectiveness_pct;
	ParticleIndex_t m_nThinkerFXIndex;
	bool bLanded;
};

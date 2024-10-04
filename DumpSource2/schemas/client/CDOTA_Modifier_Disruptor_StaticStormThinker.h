class CDOTA_Modifier_Disruptor_StaticStormThinker : public CDOTA_Buff
{
	int32 m_nCurrentPulse;
	float32 radius;
	int32 damage_max;
	int32 pulses;
	float32 duration;
	ParticleIndex_t m_nFXIndex;
}

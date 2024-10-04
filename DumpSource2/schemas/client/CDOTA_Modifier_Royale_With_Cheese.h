class CDOTA_Modifier_Royale_With_Cheese : public CDOTA_Buff
{
	float32 shield;
	float32 regen;
	float32 idle;
	int32 m_nDamageAbsorbed;
	GameTime_t m_timeLastTick;
	GameTime_t m_timeLastDamage;
	ParticleIndex_t nFXIndex;
};

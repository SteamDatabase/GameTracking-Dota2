class CDOTA_Modifier_Windrunner_GaleForce : public CDOTA_Buff
{
	Vector m_vEndpoint;
	Vector m_vFlowPosition;
	Vector m_vPull;
	ParticleIndex_t m_nFXIndex;
	GameTime_t m_flLastThinkTime;
	float32 wind_strength;
}

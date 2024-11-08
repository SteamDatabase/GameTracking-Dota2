class C_DOTA_Ability_Kez_RaptorDance : public C_DOTA_Ability_Kez_BaseAbility
{
	int32 radius;
	int32 invulnerable;
	int32 strikes;
	float32 strike_interval;
	int32 m_nStrikesLeft;
	bool m_bChannelFinished;
	GameTime_t m_NextStrikeTime;
	ParticleIndex_t m_nChannelParticle;
};

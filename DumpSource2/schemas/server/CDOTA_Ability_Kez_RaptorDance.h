class CDOTA_Ability_Kez_RaptorDance
{
	int32 radius;
	int32 invulnerable;
	int32 strikes;
	float32 strike_interval;
	int32 m_nStrikesLeft;
	bool m_bChannelFinished;
	bool m_bHitAnyTarget;
	GameTime_t m_NextStrikeTime;
	ParticleIndex_t m_nChannelParticle;
};

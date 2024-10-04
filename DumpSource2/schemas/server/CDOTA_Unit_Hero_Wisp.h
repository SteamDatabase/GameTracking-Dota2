class CDOTA_Unit_Hero_Wisp : public CDOTA_BaseNPC_Hero
{
	ParticleIndex_t m_nAmbientFXIndex;
	ParticleIndex_t m_nStunnedFXIndex;
	ParticleIndex_t m_nTalkFXIndex;
	ParticleIndex_t m_nIllusionFXIndex;
	bool m_bParticleHexed;
	bool m_bParticleStunned;
	bool m_bDetermineAmbientEffect;
	float32 m_flPrevHealth;
};

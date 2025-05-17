class C_DOTA_Ability_Elder_Titan_EchoStomp : public C_DOTABaseAbility
{
	ParticleIndex_t m_nFXIndexTitan;
	ParticleIndex_t m_nFXIndexSpirit;
	ParticleIndex_t m_nFXIndexTitanB;
	ParticleIndex_t m_nFXIndexSpiritB;
	float32 radius;
	float32 stomp_damage;
	float32 sleep_duration;
	float32 cast_time;
	CUtlVector< CHandle< C_BaseEntity > > m_vecStompedHeroes;
	CUtlVector< CHandle< C_BaseEntity > > m_vecStompedHeroes_BuffCounted;
	bool m_bStompedInvisibleHero;
};

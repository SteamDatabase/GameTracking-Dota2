class CDOTA_Ability_Elder_Titan_EchoStomp : public CDOTABaseAbility
{
	ParticleIndex_t m_nFXIndexTitan;
	ParticleIndex_t m_nFXIndexSpirit;
	ParticleIndex_t m_nFXIndexTitanB;
	ParticleIndex_t m_nFXIndexSpiritB;
	int32 radius;
	int32 stomp_damage;
	float32 sleep_duration;
	float32 cast_time;
	CUtlVector< CHandle< CBaseEntity > > m_vecStompedHeroes;
	CUtlVector< CHandle< CBaseEntity > > m_vecStompedHeroes_BuffCounted;
	bool m_bStompedInvisibleHero;
}

class C_DOTA_Ability_Shredder_Chakram : public C_DOTABaseAbility
{
	float32 radius;
	float32 speed;
	float32 pass_slow_duration;
	int32 pass_damage;
	Vector m_vEndLocation;
	float32 m_fZCoord;
	bool m_bIsReturning;
	ParticleIndex_t m_nFXIndex;
	ParticleIndex_t m_nFXIndexB;
	ParticleIndex_t m_nFXIndexC;
	int32 m_nProjectileIndex;
	CHandle< C_BaseEntity > m_hThinker;
	CUtlVector< CHandle< C_BaseEntity > > m_hReturnHits;
};

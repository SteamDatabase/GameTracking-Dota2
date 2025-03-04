class CDOTA_Ability_Dawnbreaker_Celestial_Hammer
{
	int32 m_nProjectileIndex;
	int32 m_nReturnProjectileID;
	Vector m_vEndLocation;
	float32 m_fZCoord;
	Vector m_vLastTrailThinkerLocation;
	bool m_bFlareDone;
	bool m_bStartedCatchAnimation;
	bool m_bIsReturning;
	CUtlVector< CHandle< CBaseEntity > > m_hReturnHits;
	CUtlVector< CHandle< CBaseEntity > > m_hAoEHits;
	ParticleIndex_t m_nFXIndex;
	ParticleIndex_t m_nFXIndexC;
	ParticleIndex_t m_nFXHammerReturnIndex;
	ParticleIndex_t m_nFXHammerProjectileIndex;
	ParticleIndex_t m_nFXHeroSolarGuardianTrailIndex;
	CHandle< CBaseEntity > m_hThinker;
	float32 projectile_speed;
	float32 projectile_radius;
	float32 hammer_damage;
	float32 hammer_aoe_radius;
	float32 flare_radius;
	float32 fire_trail_health_regen;
	bool bHasStartedBurning;
	float32 flare_debuff_duration;
	int32 return_anim_distance_threshold;
	float32 range;
};

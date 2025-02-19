class CDOTA_Ability_Spectre_SpectralDagger
{
	float32 dagger_path_duration;
	float32 hero_path_duration;
	float32 m_fCreateInterval;
	GameTime_t m_fLastCreate;
	Vector m_vecLastPosition;
	bool m_bIsTrackingProjectile;
	CUtlVector< CHandle< CBaseEntity > > m_hTrackingProjectileHits;
	CUtlVector< CHandle< CBaseEntity > > m_hUnitsHit;
	bool m_bIsThinkHit;
	CHandle< CBaseEntity > m_hTrackingTarget;
};

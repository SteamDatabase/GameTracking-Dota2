class C_DOTA_Ability_Spectre_SpectralDagger : public C_DOTABaseAbility
{
	float32 dagger_path_duration;
	float32 hero_path_duration;
	float32 m_fCreateInterval;
	GameTime_t m_fLastCreate;
	Vector m_vecLastPosition;
	bool m_bIsTrackingProjectile;
	CUtlVector< CHandle< C_BaseEntity > > m_hTrackingProjectileHits;
	CUtlVector< CHandle< C_BaseEntity > > m_hUnitsHit;
	bool m_bIsThinkHit;
	CHandle< C_BaseEntity > m_hTrackingTarget;
};

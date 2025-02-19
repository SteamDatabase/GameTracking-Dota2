class CDOTA_Modifier_AghsFort_Firefly
{
	float32 pool_duration;
	int32 radius;
	int32 m_ifirefly_Active;
	int32 tree_radius;
	int32 damage_pct_per_second;
	int32 movement_speed;
	float32 trail_placement_duration;
	float32 burn_linger_duration;
	bool m_bActive;
	ParticleIndex_t m_nFXIndex;
	ParticleIndex_t m_nFXIndexB;
	GameTime_t m_flStartTime;
	Vector m_vLastFirePoolLoc;
	CUtlVector< Vector > m_vFirePoolLocations;
};

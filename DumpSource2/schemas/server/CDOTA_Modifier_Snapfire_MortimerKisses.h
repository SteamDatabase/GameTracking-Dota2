class CDOTA_Modifier_Snapfire_MortimerKisses
{
	float32 m_fIntervalPerRocket;
	float32 m_flFacingTarget;
	ParticleIndex_t m_nBeamFXIndex;
	CHandle< CBaseEntity > m_hBeamEnd;
	float32 m_flCurDistance;
	Vector m_vAimTarget;
	float32 m_fLastTurnAmount;
	int32 m_nProjectilesLaunched;
	bool m_bDestroyOnNextThink;
	int32 m_nProjectilesToLaunch;
	bool m_bHasProjectileTalent;
	int32 projectile_count;
	float32 projectile_speed;
	float32 projectile_width;
	float32 projectile_vision;
	float32 turn_rate;
	float32 min_range;
	float32 impact_radius;
	float32 min_lob_travel_time;
	float32 max_lob_travel_time;
	float32 delay_after_last_projectile;
};

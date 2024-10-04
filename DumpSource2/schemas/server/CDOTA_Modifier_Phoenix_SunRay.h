class CDOTA_Modifier_Phoenix_SunRay : public CDOTA_Buff
{
	int32 hp_cost_perc_per_second;
	int32 beam_range;
	int32 base_damage;
	int32 base_heal;
	float32 tick_interval;
	float32 forward_move_speed;
	float32 turn_rate_initial;
	float32 turn_rate;
	int32 radius;
	float32 m_flCurrentTime;
	float32 m_flAccumulatedSelfDamage;
	bool m_bMovingForward;
	bool m_bTurningFast;
	float32 m_flFacingTarget;
	float32 hp_perc_damage;
	float32 hp_perc_heal;
	float32 blind_duration;
	int32 blind_per_second;
	int32 focal_point_max_multiplier;
	int32 focal_point_start_length_pct;
	ParticleIndex_t m_nBeamFXIndex;
	CHandle< CBaseEntity >[8] m_hVisionThinkers;
	CHandle< CBaseEntity > m_hBeamEnd;
	bool m_bCreatedVisionThinkers;
	CHandle< CBaseEntity > m_hBeamEndSound;
};

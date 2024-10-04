class CDOTA_Modifier_AghsFort_AssaultCaptain_SunRay : public CDOTA_Buff
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
	int32 self_turn_rate_percent;
	float32 m_flCurrentTime;
	GameTime_t m_flLastDamageTime;
	float32 m_flAccumulatedSelfDamage;
	bool m_bMovingForward;
	bool m_bTurningFast;
	float32 m_flFacingTarget;
	float32 hp_perc_damage;
	float32 hp_perc_heal;
	ParticleIndex_t m_nBeamFXIndex;
	CHandle< C_BaseEntity >[8] m_hVisionThinkers;
	CHandle< C_BaseEntity > m_hBeamEnd;
	bool m_bCreatedVisionThinkers;
	CHandle< C_BaseEntity > m_hBeamEndSound;
}

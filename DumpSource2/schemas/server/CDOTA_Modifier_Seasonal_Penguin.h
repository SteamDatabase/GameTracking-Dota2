class CDOTA_Modifier_Seasonal_Penguin : public CDOTA_Buff
{
	float32 m_fLifetimeGained;
	Vector m_vTargetPos;
	int32 m_nCurrentSpeed;
	GameTime_t m_fLastBumpTime;
	Vector m_vLastPos;
	CHandle< CBaseEntity > m_hLastHit;
	Vector m_vDir;
	Vector m_vRunEndPos;
	bool m_bIsInInitialRun;
	Vector m_vJumpEndPos;
	bool m_bPlayedVroomSinceLastCrash;
	ParticleIndex_t m_nVroomFX;
	GameTime_t m_fLastSpeedStepTime;
	GameTime_t m_fLastSpeechTime;
	ParticleIndex_t m_nFXStackIndex;
	int32 m_nBumpsSinceLastCrash;
	CHandle< CBaseEntity > m_hLastBumpingHero;
	int32 initial_speed;
	int32 max_speed;
	int32 speed_step;
	float32 speed_step_interval;
	float32 bump_delay;
	float32 bump_delay_absolute;
	int32 bump_collision_radius;
	int32 run_distance;
	int32 jump_distance;
	int32 speed_after_crash;
	int32 speed_gain_per_hero_bump;
	float32 max_gainable_lifetime;
	float32 lifetime_gain_per_hero_bump;
	float32 min_speech_repeat_time;
}

class CDOTA_Modifier_Marci_Unleash_Flurry
{
	int32 flurry_bonus_attack_speed;
	float32 time_between_flurries;
	float32 debuff_duration;
	float32 max_time_window_per_hit;
	bool m_bBonusSpeed;
	ParticleIndex_t m_nFXStackIndex;
	bool m_bIsDoingFlurryAttack;
	bool m_bIsDoingFlurryPulseAttack;
	GameTime_t m_fLastAttackTime;
	bool m_bShouldConsiderSilence;
};

class CDOTA_Modifier_Alchemist_UnstableConcoction
{
	float32 brew_time;
	float32 brew_explosion;
	GameTime_t m_fStartTime;
	GameTime_t m_fLastAlertTime;
	ParticleIndex_t m_nConcoctionFXIndex;
	bool m_bHasStunned;
	int32 damage_resistance;
	int32 move_speed;
};

class CDOTA_Modifier_Seasonal_TI11_RockPaperScissors : public CDOTA_Buff
{
	float32 challenge_duration;
	float32 reveal_duration;
	float32 reveal_delay;
	float32 completed_cooldown;
	float32 think_interval;
	float32 acknowledge_range;
	GameTime_t m_flRevealTime;
	ParticleIndex_t m_nOverheadFXIndex;
}

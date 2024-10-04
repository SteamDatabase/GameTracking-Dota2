class CDOTA_Modifier_GlimmerCape_Fade : public CDOTA_Buff
{
	int32 active_movement_speed;
	int32 barrier_block;
	int32 barrier_amount;
	float32 initial_fade_delay;
	float32 secondary_fade_delay;
	float32 m_flFadeTime;
	float32 m_flCurentFadeDelay;
	GameTime_t m_flLastActionTime;
}

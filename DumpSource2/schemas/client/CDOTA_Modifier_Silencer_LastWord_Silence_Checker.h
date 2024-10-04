class CDOTA_Modifier_Silencer_LastWord_Silence_Checker : public CDOTA_Buff
{
	int32 damage_per_silence;
	int32 slow_per_silence;
	float32 m_flTimeToNextTick;
	GameTime_t m_rtLastTick;
}

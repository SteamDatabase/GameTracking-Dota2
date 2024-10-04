class CDOTA_Modifier_Ringmaster_TameTheBeasts : public CDOTA_Buff
{
	float32 m_flPreviousMult;
	float32 m_fChannelTime;
	GameTime_t m_fStartTime;
	ParticleIndex_t m_nFXIndex;
	int32 has_debuff_immunity;
	int32 magic_resist;
}

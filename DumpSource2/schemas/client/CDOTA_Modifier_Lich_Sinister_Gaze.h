class CDOTA_Modifier_Lich_Sinister_Gaze : public CDOTA_Buff
{
	int32 movement_speed;
	int32 mana_drain;
	float32 m_flIntervalRate;
	ParticleIndex_t m_nFXIndex;
	bool m_bBlasted;
	float32 post_gaze_debuff_duration_multiplier;
};

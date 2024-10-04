class CDOTA_Modifier_Abaddon_Withering_Mist_Debuff : public CDOTA_Buff
{
	int32 heal_reduction_pct;
	int32 hp_threshold_pct;
	ParticleIndex_t m_nFXIndex;
	bool bUnderThreshold;
};

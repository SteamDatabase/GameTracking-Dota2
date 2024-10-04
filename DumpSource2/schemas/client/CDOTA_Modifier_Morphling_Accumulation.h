class CDOTA_Modifier_Morphling_Accumulation : public CDOTA_Buff
{
	bool m_bActive;
	float32 percent_to_increment;
	float32 m_flStrengthGain;
	float32 m_flAgilityGain;
	float32 m_flIntellectGain;
	int32 nAttributeLevels;
	int32 bonus_all_stats_per_level_of_attributes;
}

class CDOTA_Modifier_Morphling_Accumulation : public CDOTA_Buff
{
	bool m_bActive;
	float32 percent_to_increment;
	float32 m_flStrengthGain;
	float32 m_flAgilityGain;
	float32 m_flIntellectGain;
	int32 m_nAttributeLevels;
	int32 bonus_primary_stat_per_level_of_attributes;
	int32 bonus_int_per_level_of_attributes;
	int32 m_nPrimaryStat;
};

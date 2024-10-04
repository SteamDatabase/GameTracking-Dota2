class CDOTA_Modifier_SkeletonKing_MortalStrike : public CDOTA_Buff
{
	int32 crit_mult;
	int32 wraith_crit_bonus;
	float32 wraith_cd_mult;
	CUtlVector< int16 > m_vCritRecords;
}

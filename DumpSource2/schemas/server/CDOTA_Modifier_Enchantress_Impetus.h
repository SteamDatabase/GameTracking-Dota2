class CDOTA_Modifier_Enchantress_Impetus : public CDOTA_Buff
{
	float32 distance_damage_pct;
	int32 distance_cap;
	float32 creep_multiplier;
	CUtlVector< int16 > m_InFlightAttackRecords;
};

class CDOTA_Modifier_DrowRanger_Marksmanship : public CDOTA_Buff
{
	int32 chance;
	ParticleIndex_t m_nFxIndex;
	CUtlVector< int16 > m_InFlightAttackRecords;
	CUtlVector< int16 > m_GlacialInFlightAttackRecords;
	int32 bonus_factor;
	int32 disable_range;
	int32 agility_range;
	int32 bonus_damage;
	int32 split_count;
	int32 split_range;
	bool m_bGlacialAttack;
}

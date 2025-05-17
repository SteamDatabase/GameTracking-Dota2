class CDOTA_Modifier_Tusk_WalrusPunch : public CDOTA_Buff
{
	int32 crit_multiplier;
	int32 bonus_damage;
	float32 air_time;
	float32 slow_duration;
	CUtlSymbolLarge m_iszRangedAttackEffect;
	CHandle< C_BaseEntity > m_hTarget;
	bool m_bWalrusPunch;
	CUtlVector< int16 > m_InFlightAttackRecords;
	ParticleIndex_t m_nFXIndex;
};

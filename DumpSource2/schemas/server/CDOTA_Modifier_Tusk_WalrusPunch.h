class CDOTA_Modifier_Tusk_WalrusPunch
{
	int32 crit_multiplier;
	int32 bonus_damage;
	float32 air_time;
	float32 slow_duration;
	CUtlSymbolLarge m_iszRangedAttackEffect;
	CHandle< CBaseEntity > m_hTarget;
	bool m_bWalrusPunch;
	CUtlVector< int16 > m_InFlightAttackRecords;
	ParticleIndex_t m_nFXIndex;
	int32 m_nAttackRecord;
};

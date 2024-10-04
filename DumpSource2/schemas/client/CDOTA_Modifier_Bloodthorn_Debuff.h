class CDOTA_Modifier_Bloodthorn_Debuff : public CDOTA_Buff
{
	float32 target_crit_multiplier;
	float32 silence_damage_percent;
	int32 proc_damage_heroes;
	int32 proc_damage_creeps;
	float32 m_flDamageTaken;
	CUtlVector< int16 > m_vRecords;
};

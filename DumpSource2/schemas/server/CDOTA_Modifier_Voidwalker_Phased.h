class CDOTA_Modifier_Voidwalker_Phased : public CDOTA_Buff
{
	int32 damage;
	float32 max_damage_duration;
	int32 attack_range_bonus;
	CUtlVector< int16 > m_InFlightAttackRecords;
	bool bAttackRange;
	float32 m_flStartTime;
	float32 m_flFadeTime;
	float32 m_flDamageScale;
	float32 duration;
}

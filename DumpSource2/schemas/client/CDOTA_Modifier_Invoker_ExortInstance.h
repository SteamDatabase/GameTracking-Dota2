class CDOTA_Modifier_Invoker_ExortInstance : public CDOTA_Modifier_Invoker_Instance
{
	int32 bonus_damage_per_instance;
	float32 magic_amp;
	float32 resist_debuff_duration;
	CUtlVector< int16 > m_InFlightAttackRecords;
}

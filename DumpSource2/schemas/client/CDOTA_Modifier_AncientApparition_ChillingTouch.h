class CDOTA_Modifier_AncientApparition_ChillingTouch : public CDOTA_Buff
{
	int32 damage;
	float32 duration;
	float32 slow_duration;
	int32 attack_range_bonus;
	CUtlVector< int16 > m_InFlightAttackRecords;
}

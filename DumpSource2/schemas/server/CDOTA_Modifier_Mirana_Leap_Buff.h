class CDOTA_Modifier_Mirana_Leap_Buff : public CDOTA_Buff
{
	int32 leap_speedbonus;
	int32 leap_speedbonus_as;
	bool m_bCritUsed;
	CUtlVector< int16 > m_vCritRecords;
}

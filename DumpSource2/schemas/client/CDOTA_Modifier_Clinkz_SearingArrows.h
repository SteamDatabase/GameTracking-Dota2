class CDOTA_Modifier_Clinkz_SearingArrows : public CDOTA_Buff
{
	int32 damage_bonus;
	CUtlVector< int16 > m_InFlightAttackRecords;
	bool m_bBonusAttack;
}

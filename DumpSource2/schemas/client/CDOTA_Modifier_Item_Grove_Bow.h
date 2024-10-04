class CDOTA_Modifier_Item_Grove_Bow : public CDOTA_Buff_Item
{
	int32 attack_range_bonus;
	int32 attack_speed_bonus;
	CUtlVector< int16 > m_InFlightAttackRecords;
}

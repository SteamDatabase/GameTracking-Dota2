class CDOTA_Modifier_Item_Javelin : public CDOTA_Buff_Item
{
	int32 bonus_chance;
	int32 bonus_chance_damage;
	CUtlVector< int16 > m_InFlightAttackRecords;
};

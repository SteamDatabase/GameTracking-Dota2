class CDOTA_Modifier_Item_Skadi : public CDOTA_Buff_Item
{
	int32 bonus_all_stats;
	int32 bonus_health;
	int32 bonus_mana;
	float32 cold_duration;
	CUtlVector< int16 > m_InFlightAttackRecords;
};

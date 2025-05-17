class CDOTA_Modifier_Item_SerratedShiv : public CDOTA_Buff_Item
{
	int32 proc_chance;
	float32 hp_dmg;
	float32 hp_dmg_rosh;
	CUtlVector< int16 > m_InFlightAttackRecords;
};

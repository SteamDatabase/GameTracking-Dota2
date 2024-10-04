class CDOTA_Modifier_Item_Venom_Gland : public CDOTA_Buff_Item
{
	int32 primary_attribute;
	int32 debuff_amp;
	float32 duration;
	CUtlVector< int16 > m_InFlightAttackRecords;
}

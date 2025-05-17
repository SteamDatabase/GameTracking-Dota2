class CDOTA_Modifier_Item_Orb_Of_Frost : public CDOTA_Buff_Item
{
	int32 armor;
	int32 attack_speed;
	float32 duration;
	CUtlVector< int16 > m_InFlightAttackRecords;
};

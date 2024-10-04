class CDOTA_Modifier_Item_InvisibilityEdge : public CDOTA_Buff_Item
{
	int32 bonus_attack_speed;
	int32 bonus_damage;
	CUtlVector< int16 > m_InFlightAttackRecords;
}

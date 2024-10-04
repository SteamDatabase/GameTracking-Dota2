class CDOTA_Modifier_Item_Enchanted_Quiver : public CDOTA_Buff_Item
{
	int32 bonus_attack_range;
	int32 bonus_damage;
	int32 active_bonus_attack_range;
	CUtlVector< int16 > m_InFlightAttackRecords;
};

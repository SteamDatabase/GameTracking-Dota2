class CDOTA_Modifier_Item_Harpoon : public CDOTA_Buff_Item
{
	int32 bonus_chance;
	int32 bonus_chance_damage;
	int32 bonus_strength;
	int32 bonus_agility;
	int32 bonus_intellect;
	float32 bonus_mana_regen;
	int32 bonus_damage;
	int32 bonus_speed;
	CUtlVector< int16 > m_InFlightProcAttackRecords;
}

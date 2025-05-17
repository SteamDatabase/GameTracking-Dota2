class CDOTA_Modifier_Item_CraniumBasher : public CDOTA_Buff_Item
{
	int32 bonus_strength;
	int32 bash_chance_melee;
	int32 bash_chance_ranged;
	float32 bash_duration;
	float32 bash_cooldown;
	int32 bonus_chance_damage;
	int32 bonus_damage;
	CUtlVector< int16 > m_InFlightAttackRecords;
};

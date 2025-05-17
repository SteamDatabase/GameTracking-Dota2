class CDOTA_Modifier_Item_Tenderizer : public CDOTA_Buff_Item
{
	int32 bonus_strength;
	int32 bonus_agility;
	int32 bash_chance_melee;
	int32 bash_chance_ranged;
	float32 bash_duration;
	float32 bash_cooldown;
	int32 bonus_chance_damage;
	int32 bonus_damage;
	int32 weaken_per_hit;
	float32 weaken_duration;
	CUtlVector< int16 > m_InFlightAttackRecords;
};

class CDOTA_Modifier_Item_Witch_Blade : public CDOTA_Buff_Item
{
	int32 bonus_intellect;
	int32 bonus_attack_speed;
	int32 bonus_armor;
	float32 slow_duration;
	float32 bonus_mana_regen;
	int32 projectile_speed;
	CUtlVector< int16 > m_InFlightAttackRecords;
};

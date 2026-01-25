class CDOTA_Modifier_Brewmaster_DrunkenBrawler_Passive : public CDOTA_Buff
{
	float32 bonus_armor;
	float32 magic_resist;
	float32 dodge_chance;
	float32 bonus_move_speed;
	float32 crit_chance;
	float32 crit_multiplier;
	float32 attack_speed;
	float32 brewed_up_duration;
	float32 brewed_up_duration_extend;
	float32 brewed_up_bonus;
	bool m_bBrewedUp;
	CUtlVector< int16 > m_InFlightAttackRecords;
};

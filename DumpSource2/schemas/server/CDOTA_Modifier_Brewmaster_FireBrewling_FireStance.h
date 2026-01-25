class CDOTA_Modifier_Brewmaster_FireBrewling_FireStance : public CDOTA_Buff
{
	int32 attack_speed;
	int32 crit_chance;
	int32 crit_damage;
	CUtlVector< int16 > m_InFlightAttackRecords;
};

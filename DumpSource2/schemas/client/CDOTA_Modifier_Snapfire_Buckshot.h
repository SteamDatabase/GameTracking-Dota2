class CDOTA_Modifier_Snapfire_Buckshot : public CDOTA_Buff
{
	int32 miss_chance;
	int32 damage_amp;
	int32 split_shot;
	int32 glancing_shot_damage_pct;
	CUtlVector< int16 > m_InFlightAttackRecords;
};

class CDOTA_Modifier_Sven_GreatCleave : public CDOTA_Buff
{
	float32 cleave_starting_width;
	float32 cleave_ending_width;
	float32 cleave_distance;
	float32 great_cleave_damage;
	int32 strength_bonus;
	int16 m_nLastCleaveRecord;
	int32 m_nLastCleaveKills;
};

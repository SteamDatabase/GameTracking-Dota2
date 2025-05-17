class CDOTA_Modifier_Item_AssassinsDagger : public CDOTA_Buff_Item
{
	CUtlVector< int16 > m_InFlightAttackRecords;
	int32 debuff_duration;
	int32 bonus_attack_speed;
};

class CDOTA_Modifier_Snapfire_LilShredder_Buff : public CDOTA_Buff
{
	CUtlVector< int16 > m_InFlightAttackRecords;
	int32 m_nIsActive;
	bool m_bBonusAttack;
	int32 attack_range_bonus;
	int32 buffed_attacks;
	float32 base_attack_time;
	int32 attack_speed_bonus;
	float32 armor_duration;
	int32 extra_targets;
}

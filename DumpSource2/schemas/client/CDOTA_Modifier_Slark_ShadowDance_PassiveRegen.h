class CDOTA_Modifier_Slark_ShadowDance_PassiveRegen : public CDOTA_Buff
{
	int32 bonus_movement_speed;
	float32 bonus_regen;
	float32 corruption_duration;
	CUtlVector< int16 > m_InFlightAttackRecords;
};

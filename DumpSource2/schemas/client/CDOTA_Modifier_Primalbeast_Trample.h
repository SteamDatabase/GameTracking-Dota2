class CDOTA_Modifier_Primalbeast_Trample : public CDOTA_Buff
{
	float32 effect_radius;
	Vector vLastPos;
	float32 flCurrentDistance;
	int32 step_distance;
	int32 bonus_magic_resistance;
	bool m_bIsUnslowable;
	CUtlVector< int16 > m_InFlightAttackRecords;
}

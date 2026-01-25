class CDOTA_Modifier_Clinkz_SearingArrows : public CDOTA_Buff
{
	int32 damage_bonus;
	int32 skeleton_damage_pct;
	float32 skeleton_range;
	CUtlVector< int16 > m_InFlightAttackRecords;
	bool m_bBonusAttack;
};

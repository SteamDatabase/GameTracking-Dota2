class CDOTA_Modifier_FacelessVoid_TimeZone_Effect : public CDOTA_Buff
{
	CUtlVectorFixedGrowable< CHandle< CDOTABaseAbility >, 40 > m_vecAbilities;
	int32 bonus_move_speed;
	int32 bonus_attack_speed;
	int32 bonus_cast_speed;
	int32 bonus_turn_speed;
};

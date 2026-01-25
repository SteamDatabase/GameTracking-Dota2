class CDOTA_Modifier_Innate_Riki_Backstab : public CDOTA_Buff
{
	int32 backstab_angle;
	float32 damage_multiplier;
	float32 bonus_xp_kill;
	float32 bonus_xp_assist;
	float32 bonus_xp_assist_other;
	float32 ally_multiplier;
	bool m_bBackstab;
};

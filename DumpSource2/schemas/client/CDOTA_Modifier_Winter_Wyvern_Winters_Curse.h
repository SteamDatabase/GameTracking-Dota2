class CDOTA_Modifier_Winter_Wyvern_Winters_Curse : public CDOTA_Buff
{
	CHandle< C_BaseEntity > m_hZombieTarget;
	CHandle< C_BaseEntity > m_hDesiredTarget;
	int32 damage_reduction;
	int32 bonus_attack_speed;
};

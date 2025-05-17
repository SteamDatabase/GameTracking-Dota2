class CDOTA_Modifier_Winter_Wyvern_Winters_Curse : public CDOTA_Buff
{
	CHandle< CBaseEntity > m_hZombieTarget;
	CHandle< CBaseEntity > m_hDesiredTarget;
	int32 damage_reduction;
	int32 bonus_attack_speed;
};

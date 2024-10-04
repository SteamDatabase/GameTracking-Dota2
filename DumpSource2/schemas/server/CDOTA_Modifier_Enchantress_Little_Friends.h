class CDOTA_Modifier_Enchantress_Little_Friends : public CDOTA_Buff
{
	CHandle< CBaseEntity > m_hZombieTarget;
	CHandle< CBaseEntity > m_hDesiredTarget;
	int32 damage_reduction;
	int32 bonus_attack_speed;
	int32 bonus_move_speed;
}

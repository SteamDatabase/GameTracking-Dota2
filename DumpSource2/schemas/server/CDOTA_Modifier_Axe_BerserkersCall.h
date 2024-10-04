class CDOTA_Modifier_Axe_BerserkersCall : public CDOTA_Buff
{
	CHandle< CBaseEntity > m_hZombieTarget;
	bool m_bDidSetAttackTarget;
	int32 bonus_attack_speed;
}

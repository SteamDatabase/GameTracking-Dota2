class CDOTA_Modifier_Chen_Penitence_Self_Attack_Range : public CDOTA_Buff
{
	CHandle< CBaseEntity > m_hTarget;
	int32 self_attack_range_bonus;
	bool m_bActive;
};

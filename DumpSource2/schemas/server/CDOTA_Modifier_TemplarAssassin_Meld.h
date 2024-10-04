class CDOTA_Modifier_TemplarAssassin_Meld : public CDOTA_Buff
{
	int32 bonus_damage;
	bool launched_attack;
	CHandle< CBaseEntity > m_hTarget;
	int32 m_nAttackRecord;
}

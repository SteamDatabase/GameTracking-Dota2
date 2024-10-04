class CDOTA_Modifier_TemplarAssassin_Meld : public CDOTA_Buff
{
	int32 bonus_damage;
	bool launched_attack;
	CHandle< C_BaseEntity > m_hTarget;
	int32 m_nAttackRecord;
};

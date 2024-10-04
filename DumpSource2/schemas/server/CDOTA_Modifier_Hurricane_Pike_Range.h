class CDOTA_Modifier_Hurricane_Pike_Range : public CDOTA_Buff
{
	CHandle< CBaseEntity > m_hTarget;
	int32 max_attacks;
	int32 m_iNumAttacks;
	bool bActive;
	int32 bonus_attack_speed;
};

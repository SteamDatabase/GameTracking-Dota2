class CDOTA_Modifier_Lich_Chain_Frost_Thinker : public CDOTA_Buff
{
	int32 m_nDamageToHeroes;
	int32 m_nHeroesKilled;
	int32 m_nJumps;
	bool m_bFirstJump;
	CHandle< C_BaseEntity > m_hTarget;
	CHandle< C_BaseEntity > m_hAvoidTarget;
}

class CDOTA_Modifier_Meepo_MegaMeepo_Self : public CDOTA_Buff
{
	int32 base_strength;
	int32 base_int;
	int32 base_agi;
	int32 stats_pct;
	CHandle< C_BaseEntity > m_hMegameepoFrame;
	bool m_bWasOutOfGame;
}

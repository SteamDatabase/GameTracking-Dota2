class C_DOTA_Ability_Meepo_MegaMeepo : public C_DOTABaseAbility
{
	CHandle< C_BaseEntity > hPreviousMeepo;
	CHandle< C_BaseEntity > hMegameepoFrame;
	CUtlVector< CHandle< C_BaseEntity > > hListOfMeepos;
	bool m_bHasSwappedAbilities;
};

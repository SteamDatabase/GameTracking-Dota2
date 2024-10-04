class CDOTA_Ability_Brewmaster_PrimalSplit : public CDOTABaseAbility
{
	CHandle< CBaseEntity > m_hPrimary;
	CHandle< CBaseEntity > m_hSecondary;
	CHandle< CBaseEntity > m_hTertiary;
	CHandle< CBaseEntity > m_hFourth;
	GameTime_t m_fHurlBoulder_CooldownTime;
	GameTime_t m_fHDispelMagic_CooldownTime;
	GameTime_t m_fCyclone_CooldownTime;
	GameTime_t m_fWindWalk_CooldownTime;
	GameTime_t m_fAstralPulse_CooldownTime;
}

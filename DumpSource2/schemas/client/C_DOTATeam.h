class C_DOTATeam : public C_Team
{
	int32 m_iHeroKills;
	int32 m_iTowerKills;
	int32 m_iBarracksKills;
	uint32 m_unTournamentTeamID;
	uint64 m_ulTeamLogo;
	uint64 m_ulTeamBaseLogo;
	uint64 m_ulTeamBannerLogo;
	bool m_bTeamComplete;
	bool m_bTeamIsHomeTeam;
	bool m_bTeamCanSeeRoshanTimer;
	bool m_bTeamCanSeeNextPowerRune;
	Color m_CustomHealthbarColor;
	char[33] m_szTag;
};

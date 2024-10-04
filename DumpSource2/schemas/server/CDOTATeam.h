class CDOTATeam : public CTeam
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
	int32 m_event_lobby_updated;
	int32 m_nKillStreak;
	int32 m_iRecentKillCount;
	int32 m_iRandomNumber;
	CountdownTimer m_RecentHeroKillTimer;
}

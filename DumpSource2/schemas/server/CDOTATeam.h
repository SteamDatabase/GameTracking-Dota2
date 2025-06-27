// MNetworkVarNames = "int m_iHeroKills"
// MNetworkVarNames = "int m_iTowerKills"
// MNetworkVarNames = "int m_iBarracksKills"
// MNetworkVarNames = "uint32 m_unTournamentTeamID"
// MNetworkVarNames = "uint64 m_ulTeamLogo"
// MNetworkVarNames = "uint64 m_ulTeamBaseLogo"
// MNetworkVarNames = "uint64 m_ulTeamBannerLogo"
// MNetworkVarNames = "bool m_bTeamComplete"
// MNetworkVarNames = "bool m_bTeamIsHomeTeam"
// MNetworkVarNames = "bool m_bTeamCanSeeExactRoshanTimer"
// MNetworkVarNames = "bool m_bTeamCanSeeNextPowerRune"
// MNetworkVarNames = "Color m_CustomHealthbarColor"
// MNetworkVarNames = "char m_szTag"
class CDOTATeam : public CTeam
{
	// MNetworkEnable
	int32 m_iHeroKills;
	// MNetworkEnable
	int32 m_iTowerKills;
	// MNetworkEnable
	int32 m_iBarracksKills;
	// MNetworkEnable
	uint32 m_unTournamentTeamID;
	// MNetworkEnable
	// MNetworkEncoder = "fixed64"
	uint64 m_ulTeamLogo;
	// MNetworkEnable
	// MNetworkEncoder = "fixed64"
	uint64 m_ulTeamBaseLogo;
	// MNetworkEnable
	// MNetworkEncoder = "fixed64"
	uint64 m_ulTeamBannerLogo;
	// MNetworkEnable
	bool m_bTeamComplete;
	// MNetworkEnable
	bool m_bTeamIsHomeTeam;
	// MNetworkEnable
	bool m_bTeamCanSeeExactRoshanTimer;
	// MNetworkEnable
	bool m_bTeamCanSeeNextPowerRune;
	int32 m_nTeamCanSeeNextPowerRuneRefs;
	// MNetworkEnable
	Color m_CustomHealthbarColor;
	// MNetworkEnable
	char[33] m_szTag;
	int32 m_event_lobby_updated;
	int32 m_nKillStreak;
	int32 m_iRecentKillCount;
	int32 m_iRandomNumber;
	CountdownTimer m_RecentHeroKillTimer;
};

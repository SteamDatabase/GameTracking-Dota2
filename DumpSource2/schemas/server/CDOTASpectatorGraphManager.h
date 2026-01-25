// MNetworkVarNames = "int m_rgRadiantTotalEarnedGold"
// MNetworkVarNames = "int m_rgDireTotalEarnedGold"
// MNetworkVarNames = "int m_rgRadiantTotalEarnedXP"
// MNetworkVarNames = "int m_rgDireTotalEarnedXP"
// MNetworkVarNames = "int m_rgRadiantNetWorth"
// MNetworkVarNames = "int m_rgDireNetWorth"
// MNetworkVarNames = "GameTime_t m_flTotalEarnedGoldStartTime"
// MNetworkVarNames = "GameTime_t m_flTotalEarnedGoldEndTime"
// MNetworkVarNames = "int m_nGoldGraphVersion"
// MNetworkVarNames = "int m_rgRadiantWinChance"
class CDOTASpectatorGraphManager
{
	// MNotSaved
	CNetworkVarChainer __m_pChainEntity;
	bool m_bTrackingTeamStats;
	GameTime_t m_flStartTime;
	// MNetworkEnable
	int32[64] m_rgRadiantTotalEarnedGold;
	// MNetworkEnable
	int32[64] m_rgDireTotalEarnedGold;
	// MNetworkEnable
	int32[64] m_rgRadiantTotalEarnedXP;
	// MNetworkEnable
	int32[64] m_rgDireTotalEarnedXP;
	// MNetworkEnable
	int32[64] m_rgRadiantNetWorth;
	// MNetworkEnable
	int32[64] m_rgDireNetWorth;
	// MNetworkEnable
	GameTime_t m_flTotalEarnedGoldStartTime;
	// MNetworkEnable
	GameTime_t m_flTotalEarnedGoldEndTime;
	// MNetworkEnable
	int32 m_nGoldGraphVersion;
	// MNetworkEnable
	int32[64] m_rgRadiantWinChance;
	CountdownTimer m_TeamStatsUpdateTimer;
	CountdownTimer m_HeroInventorySnapshotTimer;
	CUtlVector< sPlayerSnapshot >[24] m_vecPlayerSnapshots;
	int32 m_event_dota_player_killed;
	int32 m_event_server_pre_shutdown;
};

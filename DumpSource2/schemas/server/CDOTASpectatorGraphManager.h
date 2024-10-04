class CDOTASpectatorGraphManager
{
	CNetworkVarChainer __m_pChainEntity;
	bool m_bTrackingTeamStats;
	GameTime_t m_flStartTime;
	int32[64] m_rgRadiantTotalEarnedGold;
	int32[64] m_rgDireTotalEarnedGold;
	int32[64] m_rgRadiantTotalEarnedXP;
	int32[64] m_rgDireTotalEarnedXP;
	int32[64] m_rgRadiantNetWorth;
	int32[64] m_rgDireNetWorth;
	GameTime_t m_flTotalEarnedGoldStartTime;
	GameTime_t m_flTotalEarnedGoldEndTime;
	int32 m_nGoldGraphVersion;
	int32[64] m_rgRadiantWinChance;
	CountdownTimer m_TeamStatsUpdateTimer;
	CountdownTimer m_HeroInventorySnapshotTimer;
	CUtlVector< sPlayerSnapshot >[24] m_vecPlayerSnapshots;
	int32 m_event_dota_player_killed;
	int32 m_event_server_pre_shutdown;
}

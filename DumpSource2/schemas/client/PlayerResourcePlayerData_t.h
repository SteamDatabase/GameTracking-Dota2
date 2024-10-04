class PlayerResourcePlayerData_t
{
	bool m_bIsValid;
	CUtlSymbolLarge m_iszPlayerName;
	int32 m_iPlayerTeam;
	bool m_bFullyJoinedServer;
	bool m_bFakeClient;
	bool m_bIsBroadcaster;
	uint32 m_iBroadcasterChannel;
	uint32 m_iBroadcasterChannelSlot;
	bool m_bIsBroadcasterChannelCameraman;
	int32 m_iConnectionState;
	uint64 m_iPlayerSteamID;
	DOTATeam_t m_eCoachTeam;
	C_NetworkUtlVectorBase< PlayerID_t > m_vecPrivateCoachPlayerIDs;
	uint32 m_unCoachRating;
	DOTATeam_t m_eLiveSpectatorTeam;
	int32 m_nLiveSpectatorSpectatedHeroIndex;
	bool m_bIsPlusSubscriber;
	bool m_bWasMVPLastGame;
	CavernCrawlMapVariant_t m_nCavernCrawlMapVariant;
	int32[3] m_eAccoladeType;
	uint64[3] m_unAccoladeData;
	int32 m_iRankTier;
	int32 m_iLeaderboardRank;
	int32 m_eMmrBoostType;
	int32 m_iTitle;
	uint64 m_unFavTeamPacked;
	CPlayerSlot m_nPlayerSlot;
	bool m_bIsBot;
	bool[5] m_bHasNeutralTier;
	bool[5] m_bHasRedeemedNeutralTier;
	int32 m_nCommLevel;
	int32 m_nBehaviorLevel;
	float32 m_flLastCommsTime;
}

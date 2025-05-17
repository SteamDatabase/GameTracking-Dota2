// MNetworkVarNames = "bool m_bIsValid"
// MNetworkVarNames = "string_t m_iszPlayerName"
// MNetworkVarNames = "int m_iPlayerTeam"
// MNetworkVarNames = "bool m_bFullyJoinedServer"
// MNetworkVarNames = "bool m_bFakeClient"
// MNetworkVarNames = "bool m_bIsBroadcaster"
// MNetworkVarNames = "uint32 m_iBroadcasterChannel"
// MNetworkVarNames = "uint32 m_iBroadcasterChannelSlot"
// MNetworkVarNames = "bool m_bIsBroadcasterChannelCameraman"
// MNetworkVarNames = "int m_iConnectionState"
// MNetworkVarNames = "uint64 m_iPlayerSteamID"
// MNetworkVarNames = "DOTATeam_t m_eCoachTeam"
// MNetworkVarNames = "PlayerID_t m_vecPrivateCoachPlayerIDs"
// MNetworkVarNames = "CoachRating_t m_unCoachRating"
// MNetworkVarNames = "DOTATeam_t m_eLiveSpectatorTeam"
// MNetworkVarNames = "int m_nLiveSpectatorSpectatedHeroIndex"
// MNetworkVarNames = "bool m_bIsPlusSubscriber"
// MNetworkVarNames = "bool m_bWasMVPLastGame"
// MNetworkVarNames = "CavernCrawlMapVariant_t m_nCavernCrawlMapVariant"
// MNetworkVarNames = "int m_eAccoladeType"
// MNetworkVarNames = "uint64 m_unAccoladeData"
// MNetworkVarNames = "int m_iRankTier"
// MNetworkVarNames = "int m_iLeaderboardRank"
// MNetworkVarNames = "int m_eMmrBoostType"
// MNetworkVarNames = "int m_iTitle"
// MNetworkVarNames = "uint64 m_unFavTeamPacked"
// MNetworkVarNames = "CPlayerSlot m_nPlayerSlot"
// MNetworkVarNames = "bool m_bIsBot"
// MNetworkVarNames = "bool m_bHasNeutralTier"
// MNetworkVarNames = "bool m_bHasRedeemedNeutralTier"
// MNetworkVarNames = "int m_nCommLevel"
// MNetworkVarNames = "int m_nBehaviorLevel"
// MNetworkVarNames = "float m_flLastCommsTime"
class PlayerResourcePlayerData_t
{
	// MNetworkEnable
	bool m_bIsValid;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnPlayerDataPlayerNamesChanged"
	CUtlSymbolLarge m_iszPlayerName;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnPlayerDataTeamChanged"
	int32 m_iPlayerTeam;
	// MNetworkEnable
	bool m_bFullyJoinedServer;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnPlayerDataFakeClientChanged"
	bool m_bFakeClient;
	// MNetworkEnable
	bool m_bIsBroadcaster;
	// MNetworkEnable
	uint32 m_iBroadcasterChannel;
	// MNetworkEnable
	uint32 m_iBroadcasterChannelSlot;
	// MNetworkEnable
	bool m_bIsBroadcasterChannelCameraman;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnPlayerDataPlayerConnectionStateChanged"
	int32 m_iConnectionState;
	// MNetworkEnable
	// MNetworkEncoder = "fixed64"
	// MNetworkChangeCallback = "OnPlayerDataPlayerSteamIDsChanged"
	uint64 m_iPlayerSteamID;
	// MNetworkEnable
	DOTATeam_t m_eCoachTeam;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnPlayerDataPlayerCoachedPlayerIDsChanged"
	CNetworkUtlVectorBase< PlayerID_t > m_vecPrivateCoachPlayerIDs;
	// MNetworkEnable
	uint32 m_unCoachRating;
	// MNetworkEnable
	DOTATeam_t m_eLiveSpectatorTeam;
	// MNetworkEnable
	int32 m_nLiveSpectatorSpectatedHeroIndex;
	// MNetworkEnable
	bool m_bIsPlusSubscriber;
	// MNetworkEnable
	bool m_bWasMVPLastGame;
	// MNetworkEnable
	CavernCrawlMapVariant_t m_nCavernCrawlMapVariant;
	// MNetworkEnable
	int32[3] m_eAccoladeType;
	// MNetworkEnable
	uint64[3] m_unAccoladeData;
	// MNetworkEnable
	int32 m_iRankTier;
	// MNetworkEnable
	int32 m_iLeaderboardRank;
	// MNetworkEnable
	int32 m_eMmrBoostType;
	// MNetworkEnable
	int32 m_iTitle;
	// MNetworkEnable
	uint64 m_unFavTeamPacked;
	// MNetworkEnable
	CPlayerSlot m_nPlayerSlot;
	// MNetworkEnable
	bool m_bIsBot;
	// MNetworkEnable
	bool[5] m_bHasNeutralTier;
	// MNetworkEnable
	bool[5] m_bHasRedeemedNeutralTier;
	// MNetworkEnable
	int32 m_nCommLevel;
	// MNetworkEnable
	int32 m_nBehaviorLevel;
	// MNetworkEnable
	float32 m_flLastCommsTime;
};

// MNetworkVarNames = "int m_CompendiumChallengeEventID"
// MNetworkVarNames = "int m_CompendiumChallengeSequenceID"
// MNetworkVarNames = "int m_CompendiumChallengeCoinReward"
// MNetworkVarNames = "int m_CompendiumChallengeCoinSplash"
// MNetworkVarNames = "int m_CompendiumChallengePointReward"
// MNetworkVarNames = "bool m_CompendiumChallengeCompleted"
// MNetworkVarNames = "bool m_CompendiumChallengeFailed"
// MNetworkVarNames = "int m_CompendiumChallengeProgress"
// MNetworkVarNames = "int m_QueryIDForProgress"
// MNetworkVarNames = "CDOTASubChallengeInfo m_SubChallenges"
// MNetworkVarNames = "int m_CompendiumCoinWager"
// MNetworkVarNames = "itemid_t m_CompendiumTokenWagerItemID"
// MNetworkVarNames = "int m_CompendiumWagerTokenBonusPct"
// MNetworkVarNames = "int m_CompendiumCoinWagerResults"
// MNetworkVarNames = "int m_CompendiumRankWagers"
// MNetworkVarNames = "float m_flWagerTimer"
// MNetworkVarNames = "GameTime_t m_flWagerEndTime"
// MNetworkVarNames = "CDOTA_PlayerChallengeInfo m_CompendiumChallengeInfo"
// MNetworkVarNames = "CDOTA_CombatLogQueryProgress m_PlayerQueryIDs"
// MNetworkVarNames = "int m_ProgressForQueryID"
// MNetworkVarNames = "int m_GoalForQueryID"
// MNetworkVarNames = "int m_PlayerQuestRankPreviouslyCompleted"
// MNetworkVarNames = "int m_PlayerQuestRankCompleted"
// MNetworkVarNames = "PlayerID_t m_PlayerBountyTarget"
// MNetworkVarNames = "GameTime_t m_flPlayerBountyTimestamp"
// MNetworkVarNames = "int m_PlayerBountyCount"
class CIngameEvent_Base : public CBaseEntity
{
	bool m_bInitialized;
	// MNetworkEnable
	int32[24] m_CompendiumChallengeEventID;
	// MNetworkEnable
	int32[24] m_CompendiumChallengeSequenceID;
	// MNetworkEnable
	int32[24] m_CompendiumChallengeCoinReward;
	// MNetworkEnable
	int32[24] m_CompendiumChallengeCoinSplash;
	// MNetworkEnable
	int32[24] m_CompendiumChallengePointReward;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnClientPlayerChallengeProgressChanged"
	bool[24] m_CompendiumChallengeCompleted;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnClientPlayerChallengeProgressChanged"
	bool[24] m_CompendiumChallengeFailed;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnClientPlayerChallengeProgressChanged"
	int32[24] m_CompendiumChallengeProgress;
	// MNetworkEnable
	int32[24] m_QueryIDForProgress;
	// MNetworkEnable
	CUtlVectorEmbeddedNetworkVar< CDOTASubChallengeInfo > m_SubChallenges;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnWagerChanged"
	int32[10] m_CompendiumCoinWager;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnWagerChanged"
	itemid_t[10] m_CompendiumTokenWagerItemID;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnWagerChanged"
	int32[10] m_CompendiumWagerTokenBonusPct;
	// MNetworkEnable
	int32[10] m_CompendiumCoinWagerResults;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnWagerChanged"
	int32[10] m_CompendiumRankWagers;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnWagerTimeChanged"
	float32 m_flWagerTimer;
	// MNetworkEnable
	GameTime_t m_flWagerEndTime;
	// MNetworkEnable
	CUtlVectorEmbeddedNetworkVar< CDOTA_PlayerChallengeInfo > m_CompendiumChallengeInfo;
	// MNetworkEnable
	// MNetworkTypeAlias = "DOTA_CombatLogQueryProgress"
	CUtlVectorEmbeddedNetworkVar< CDOTA_CombatLogQueryProgress > m_PlayerQueryIDs;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnClientPlayerChallengeProgressChanged"
	int32[100] m_ProgressForQueryID;
	// MNetworkEnable
	int32[100] m_GoalForQueryID;
	// MNetworkEnable
	int32[10] m_PlayerQuestRankPreviouslyCompleted;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnClientPlayerQuestRankChanged"
	int32[10] m_PlayerQuestRankCompleted;
	// MNetworkEnable
	PlayerID_t[10] m_PlayerBountyTarget;
	// MNetworkEnable
	GameTime_t[10] m_flPlayerBountyTimestamp;
	// MNetworkEnable
	int32[10] m_PlayerBountyCount;
	bool[10] m_bHasSpentWager;
	bool[10] m_bPendingWagerSpend;
	bool[24] m_bCavernCrawlActive;
	CavernCrawlMapVariant_t[24] m_nCavernCrawlMapVariant;
	bool m_bCavernHalfCredit;
	bool[24] m_bBountyReminded;
	bool[24] m_bBountyAnnounced;
	uint32[24] m_pCavernCrawlWinnings;
	uint32[24] m_pCavernCrawlPlusShardWinnings;
	CUtlVector< DOTACavernCrawlMapResult_t >*[24] m_ppVecCavernCrawlMapResult;
	int32 m_event_lobby_updated;
};

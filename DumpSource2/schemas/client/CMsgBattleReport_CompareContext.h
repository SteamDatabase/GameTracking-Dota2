enum CMsgBattleReport_CompareContext : uint32_t
{
	// MPropertySuppressEnumerator
	k_eCompareContextInvalid = -1,
	// MPropertyFriendlyName = "Overall Value"
	k_eAbsoluteValue = 0,
	// MPropertyFriendlyName = "Vs Rank Population"
	k_ePlayersOfSimilarRank = 1,
	// MPropertyFriendlyName = "Vs All Players"
	k_eAllPlayers = 2,
	// MPropertyFriendlyName = "Vs Personal History"
	k_ePlayersPersonalHistory = 3,
};

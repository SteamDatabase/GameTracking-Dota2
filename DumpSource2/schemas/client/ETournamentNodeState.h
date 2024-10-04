enum ETournamentNodeState : uint32_t
{
	k_ETournamentNodeState_Unknown = 0,
	k_ETournamentNodeState_Canceled = 1,
	k_ETournamentNodeState_TeamsNotYetAssigned = 2,
	k_ETournamentNodeState_InBetweenGames = 3,
	k_ETournamentNodeState_GameInProgress = 4,
	k_ETournamentNodeState_A_Won = 5,
	k_ETournamentNodeState_B_Won = 6,
	k_ETournamentNodeState_A_WonByForfeit = 7,
	k_ETournamentNodeState_B_WonByForfeit = 8,
	k_ETournamentNodeState_A_Bye = 9,
	k_ETournamentNodeState_A_Abandoned = 10,
	k_ETournamentNodeState_ServerFailure = 11,
	k_ETournamentNodeState_A_TimeoutForfeit = 12,
	k_ETournamentNodeState_A_TimeoutRefund = 13,
};

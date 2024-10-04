enum ETournamentState : uint32_t
{
	k_ETournamentState_Unknown = 0,
	k_ETournamentState_CanceledByAdmin = 1,
	k_ETournamentState_Completed = 2,
	k_ETournamentState_Merged = 3,
	k_ETournamentState_ServerFailure = 4,
	k_ETournamentState_TeamAbandoned = 5,
	k_ETournamentState_TeamTimeoutForfeit = 6,
	k_ETournamentState_TeamTimeoutRefund = 7,
	k_ETournamentState_ServerFailureGrantedVictory = 8,
	k_ETournamentState_TeamTimeoutGrantedVictory = 9,
	k_ETournamentState_InProgress = 100,
	k_ETournamentState_WaitingToMerge = 101,
};

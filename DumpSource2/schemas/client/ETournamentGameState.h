enum ETournamentGameState : uint32_t
{
	k_ETournamentGameState_Unknown = 0,
	k_ETournamentGameState_Canceled = 1,
	k_ETournamentGameState_Scheduled = 2,
	k_ETournamentGameState_Active = 3,
	k_ETournamentGameState_RadVictory = 20,
	k_ETournamentGameState_DireVictory = 21,
	k_ETournamentGameState_RadVictoryByForfeit = 22,
	k_ETournamentGameState_DireVictoryByForfeit = 23,
	k_ETournamentGameState_ServerFailure = 40,
	k_ETournamentGameState_NotNeeded = 41,
};

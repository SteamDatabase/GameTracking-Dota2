enum ETournamentEvent : uint32_t
{
	k_ETournamentEvent_None = 0,
	k_ETournamentEvent_TournamentCreated = 1,
	k_ETournamentEvent_TournamentsMerged = 2,
	k_ETournamentEvent_GameOutcome = 3,
	k_ETournamentEvent_TeamGivenBye = 4,
	k_ETournamentEvent_TournamentCanceledByAdmin = 5,
	k_ETournamentEvent_TeamAbandoned = 6,
	k_ETournamentEvent_ScheduledGameStarted = 7,
	k_ETournamentEvent_Canceled = 8,
	k_ETournamentEvent_TeamParticipationTimedOut_EntryFeeRefund = 9,
	k_ETournamentEvent_TeamParticipationTimedOut_EntryFeeForfeit = 10,
	k_ETournamentEvent_TeamParticipationTimedOut_GrantedVictory = 11,
};

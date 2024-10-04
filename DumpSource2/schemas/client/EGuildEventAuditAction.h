enum EGuildEventAuditAction : uint32_t
{
	k_EGuildEventAuditAction_Invalid = 0,
	k_EGuildEventAuditAction_DevGrant = 1,
	k_EGuildEventAuditAction_CompleteContract = 2,
	k_EGuildEventAuditAction_CompleteChallenge = 3,
	k_EGuildEventAuditAction_CompleteMatch_Winner = 4,
	k_EGuildEventAuditAction_ChallengeProgress = 5,
	k_EGuildEventAuditAction_CompleteMatch_Loser = 6,
	k_EGuildEventAuditAction_WeeklyLeaderboard = 7,
	k_EGuildEventAuditAction_ManualGrant = 8,
};

enum EPrivateCoachingSessionState : uint32_t
{
	k_ePrivateCoachingSessionState_Invalid = 0,
	k_ePrivateCoachingSessionState_SearchingForCoach = 1,
	k_ePrivateCoachingSessionState_CoachAssigned = 2,
	k_ePrivateCoachingSessionState_Finished = 3,
	k_ePrivateCoachingSessionState_Expired = 4,
	k_ePrivateCoachingSessionState_Abandoned = 5,
};

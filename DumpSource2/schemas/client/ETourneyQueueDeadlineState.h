enum ETourneyQueueDeadlineState : uint32_t
{
	k_ETourneyQueueDeadlineState_Normal = 0,
	k_ETourneyQueueDeadlineState_Missed = 1,
	k_ETourneyQueueDeadlineState_ExpiredOK = 2,
	k_ETourneyQueueDeadlineState_SeekingBye = 3,
	k_ETourneyQueueDeadlineState_EligibleForRefund = 4,
	k_ETourneyQueueDeadlineState_NA = -1,
	k_ETourneyQueueDeadlineState_ExpiringSoon = 101,
};

enum EDOTAGroupMergeResult : uint32_t
{
	k_EDOTAGroupMergeResult_OK = 0,
	k_EDOTAGroupMergeResult_FAILED_GENERIC = 1,
	k_EDOTAGroupMergeResult_NOT_LEADER = 2,
	k_EDOTAGroupMergeResult_TOO_MANY_PLAYERS = 3,
	k_EDOTAGroupMergeResult_TOO_MANY_COACHES = 4,
	k_EDOTAGroupMergeResult_ENGINE_MISMATCH = 5,
	k_EDOTAGroupMergeResult_NO_SUCH_GROUP = 6,
	k_EDOTAGroupMergeResult_OTHER_GROUP_NOT_OPEN = 7,
	k_EDOTAGroupMergeResult_ALREADY_INVITED = 8,
	k_EDOTAGroupMergeResult_NOT_INVITED = 9,
};

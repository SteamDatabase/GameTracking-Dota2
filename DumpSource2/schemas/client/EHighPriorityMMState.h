enum EHighPriorityMMState : uint32_t
{
	k_EHighPriorityMM_Unknown = 0,
	k_EHighPriorityMM_MissingMMData = 1,
	k_EHighPriorityMM_ResourceMissing = 2,
	k_EHighPriorityMM_ManuallyDisabled = 3,
	k_EHighPriorityMM_Min_Enabled = 64,
	k_EHighPriorityMM_AllRolesSelected = 65,
	k_EHighPriorityMM_UsingResource = 66,
	k_EHighPriorityMM_FiveStack = 67,
	k_EHighPriorityMM_HighDemand = 68,
};

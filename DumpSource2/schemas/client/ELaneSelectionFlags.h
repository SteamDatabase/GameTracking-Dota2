enum ELaneSelectionFlags : uint32_t
{
	k_ELaneSelectionFlags_SAFELANE = 1,
	k_ELaneSelectionFlags_OFFLANE = 2,
	k_ELaneSelectionFlags_MIDLANE = 4,
	k_ELaneSelectionFlags_SUPPORT = 8,
	k_ELaneSelectionFlags_HARDSUPPORT = 16,
	k_ELaneSelectionFlagGroup_None = 0,
	k_ELaneSelectionFlagGroup_CORE = 7,
	k_ELaneSelectionFlagGroup_SUPPORT = 24,
	k_ELaneSelectionFlagGroup_ALL = 31,
};

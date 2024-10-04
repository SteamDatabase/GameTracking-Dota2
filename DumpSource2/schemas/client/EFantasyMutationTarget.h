enum EFantasyMutationTarget : uint16_t
{
	k_eFantasyMutationTarget_None = 0,
	k_eFantasyMutationTarget_Prefix = 1,
	k_eFantasyMutationTarget_Player = 2,
	k_eFantasyMutationTarget_Suffix = 4,
	k_eFantasyMutationTarget_Rubies = 8,
	k_eFantasyMutationTarget_Sapphires = 16,
	k_eFantasyMutationTarget_Emeralds = 32,
	k_eFantasyMutationTarget_Adjacent = 64,
	k_eFantasyMutationTarget_OperationChoice = 128,
	k_eFantasyMutationTarget_AllColor = 256,
	k_eFantasyMutationTarget_OneColor = 512,
	k_eFantasyMutationTarget_FirstColor = 1024,
	k_eFantasyMutationTarget_LastColor = 2048,
	k_eFantasyMutationTarget_All = 4096,
};

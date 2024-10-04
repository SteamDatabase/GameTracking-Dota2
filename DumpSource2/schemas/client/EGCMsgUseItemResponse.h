enum EGCMsgUseItemResponse : uint32_t
{
	k_EGCMsgUseItemResponse_ItemUsed = 0,
	k_EGCMsgUseItemResponse_GiftNoOtherPlayers = 1,
	k_EGCMsgUseItemResponse_ServerError = 2,
	k_EGCMsgUseItemResponse_MiniGameAlreadyStarted = 3,
	k_EGCMsgUseItemResponse_ItemUsed_ItemsGranted = 4,
	k_EGCMsgUseItemResponse_DropRateBonusAlreadyGranted = 5,
	k_EGCMsgUseItemResponse_NotInLowPriorityPool = 6,
	k_EGCMsgUseItemResponse_NotHighEnoughLevel = 7,
	k_EGCMsgUseItemResponse_EventNotActive = 8,
	k_EGCMsgUseItemResponse_ItemUsed_EventPointsGranted = 9,
	k_EGCMsgUseItemResponse_MissingRequirement = 10,
	k_EGCMsgUseItemResponse_EmoticonUnlock_NoNew = 11,
	k_EGCMsgUseItemResponse_EmoticonUnlock_Complete = 12,
	k_EGCMsgUseItemResponse_ItemUsed_Compendium = 13,
};

enum ESupportEventRequestResult : uint32_t
{
	k_ESupportEventRequestResult_Success = 0,
	k_ESupportEventRequestResult_Timeout = 1,
	k_ESupportEventRequestResult_CantLockSOCache = 2,
	k_ESupportEventRequestResult_ItemNotInInventory = 3,
	k_ESupportEventRequestResult_InvalidItemDef = 4,
	k_ESupportEventRequestResult_InvalidEvent = 5,
	k_ESupportEventRequestResult_EventExpired = 6,
	k_ESupportEventRequestResult_InvalidSupportAccount = 7,
	k_ESupportEventRequestResult_InvalidSupportMessage = 8,
	k_ESupportEventRequestResult_InvalidEventPoints = 9,
	k_ESupportEventRequestResult_InvalidPremiumPoints = 10,
	k_ESupportEventRequestResult_InvalidActionID = 11,
	k_ESupportEventRequestResult_InvalidActionScore = 12,
	k_ESupportEventRequestResult_TransactionFailed = 13,
};

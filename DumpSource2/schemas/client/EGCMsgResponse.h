enum EGCMsgResponse : uint32_t
{
	k_EGCMsgResponseOK = 0,
	k_EGCMsgResponseDenied = 1,
	k_EGCMsgResponseServerError = 2,
	k_EGCMsgResponseTimeout = 3,
	k_EGCMsgResponseInvalid = 4,
	k_EGCMsgResponseNoMatch = 5,
	k_EGCMsgResponseUnknownError = 6,
	k_EGCMsgResponseNotLoggedOn = 7,
	k_EGCMsgFailedToCreate = 8,
};

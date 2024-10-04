enum EDevEventRequestResult : uint32_t
{
	k_EDevEventRequestResult_Success = 0,
	k_EDevEventRequestResult_NotAllowed = 1,
	k_EDevEventRequestResult_InvalidEvent = 2,
	k_EDevEventRequestResult_SqlFailure = 3,
	k_EDevEventRequestResult_Timeout = 4,
	k_EDevEventRequestResult_LockFailure = 5,
	k_EDevEventRequestResult_SDOLoadFailure = 6,
};

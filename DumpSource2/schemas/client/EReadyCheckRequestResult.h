enum EReadyCheckRequestResult : uint32_t
{
	k_EReadyCheckRequestResult_Success = 0,
	k_EReadyCheckRequestResult_AlreadyInProgress = 1,
	k_EReadyCheckRequestResult_NotInParty = 2,
	k_EReadyCheckRequestResult_SendError = 3,
	k_EReadyCheckRequestResult_UnknownError = 4,
};

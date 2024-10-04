enum ECustomGameInstallStatus : uint32_t
{
	k_ECustomGameInstallStatus_Unknown = 0,
	k_ECustomGameInstallStatus_Ready = 1,
	k_ECustomGameInstallStatus_Busy = 2,
	k_ECustomGameInstallStatus_FailedGeneric = 101,
	k_ECustomGameInstallStatus_FailedInternalError = 102,
	k_ECustomGameInstallStatus_RequestedTimestampTooOld = 103,
	k_ECustomGameInstallStatus_RequestedTimestampTooNew = 104,
	k_ECustomGameInstallStatus_CRCMismatch = 105,
	k_ECustomGameInstallStatus_FailedSteam = 106,
	k_ECustomGameInstallStatus_FailedCanceled = 107,
};

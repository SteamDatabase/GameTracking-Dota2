enum EDOTAGCSessionNeed : uint32_t
{
	k_EDOTAGCSessionNeed_Unknown = 0,
	k_EDOTAGCSessionNeed_UserNoSessionNeeded = 100,
	k_EDOTAGCSessionNeed_UserInOnlineGame = 101,
	k_EDOTAGCSessionNeed_UserInLocalGame = 102,
	k_EDOTAGCSessionNeed_UserInUIWasConnected = 103,
	k_EDOTAGCSessionNeed_UserInUINeverConnected = 104,
	k_EDOTAGCSessionNeed_UserTutorials = 105,
	k_EDOTAGCSessionNeed_UserInUIWasConnectedIdle = 106,
	k_EDOTAGCSessionNeed_UserInUINeverConnectedIdle = 107,
	k_EDOTAGCSessionNeed_GameServerOnline = 200,
	k_EDOTAGCSessionNeed_GameServerLocal = 201,
	k_EDOTAGCSessionNeed_GameServerIdle = 202,
	k_EDOTAGCSessionNeed_GameServerRelay = 203,
	k_EDOTAGCSessionNeed_GameServerLocalUpload = 204,
};

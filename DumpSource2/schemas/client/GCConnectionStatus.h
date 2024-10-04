enum GCConnectionStatus : uint32_t
{
	GCConnectionStatus_HAVE_SESSION = 0,
	GCConnectionStatus_GC_GOING_DOWN = 1,
	GCConnectionStatus_NO_SESSION = 2,
	GCConnectionStatus_NO_SESSION_IN_LOGON_QUEUE = 3,
	GCConnectionStatus_NO_STEAM = 4,
	GCConnectionStatus_SUSPENDED = 5,
	GCConnectionStatus_STEAM_GOING_DOWN = 6,
};

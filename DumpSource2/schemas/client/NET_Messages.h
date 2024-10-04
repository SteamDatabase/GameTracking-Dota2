enum NET_Messages : uint32_t
{
	net_NOP = 0,
	net_Disconnect_Legacy = 1,
	net_SplitScreenUser = 3,
	net_Tick = 4,
	net_StringCmd = 5,
	net_SetConVar = 6,
	net_SignonState = 7,
	net_SpawnGroup_Load = 8,
	net_SpawnGroup_ManifestUpdate = 9,
	net_SpawnGroup_SetCreationTick = 11,
	net_SpawnGroup_Unload = 12,
	net_SpawnGroup_LoadCompleted = 13,
	net_DebugOverlay = 15,
};

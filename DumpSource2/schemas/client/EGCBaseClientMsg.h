enum EGCBaseClientMsg : uint32_t
{
	k_EMsgGCPingRequest = 3001,
	k_EMsgGCPingResponse = 3002,
	k_EMsgGCToClientPollConvarRequest = 3003,
	k_EMsgGCToClientPollConvarResponse = 3004,
	k_EMsgGCCompressedMsgToClient = 3005,
	k_EMsgGCCompressedMsgToClient_Legacy = 523,
	k_EMsgGCToClientRequestDropped = 3006,
	k_EMsgGCClientWelcome = 4004,
	k_EMsgGCServerWelcome = 4005,
	k_EMsgGCClientHello = 4006,
	k_EMsgGCServerHello = 4007,
	k_EMsgGCClientConnectionStatus = 4009,
	k_EMsgGCServerConnectionStatus = 4010,
};

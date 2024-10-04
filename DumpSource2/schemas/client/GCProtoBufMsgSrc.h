enum GCProtoBufMsgSrc : uint32_t
{
	GCProtoBufMsgSrc_Unspecified = 0,
	GCProtoBufMsgSrc_FromSystem = 1,
	GCProtoBufMsgSrc_FromSteamID = 2,
	GCProtoBufMsgSrc_FromGC = 3,
	GCProtoBufMsgSrc_ReplySystem = 4,
	GCProtoBufMsgSrc_SpoofedSteamID = 5,
};

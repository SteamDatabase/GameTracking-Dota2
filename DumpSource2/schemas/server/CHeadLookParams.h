class CHeadLookParams
{
	CHeadLookParams::HeadLookPriority_t m_LookPriority;
	float32 m_flLookDuration;
	INextBotReply* m_pReplyWhenAimed;
	char* m_pReasonStr;
	bool m_bWaitForSteady;
	float32 m_flEaseInTime;
};

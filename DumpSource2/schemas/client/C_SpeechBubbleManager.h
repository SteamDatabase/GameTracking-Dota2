// MNetworkVarNames = "C_SpeechBubbleInfo m_SpeechBubbles"
class C_SpeechBubbleManager : public C_BaseEntity
{
	// MNetworkEnable
	// MNetworkTypeAlias = "m_SpeechBubbles"
	C_UtlVectorEmbeddedNetworkVar< C_SpeechBubbleInfo > m_SpeechBubbles;
	uint32[4] m_nLastCountInQueue;
};

class C_SpeechBubbleManager : public C_BaseEntity
{
	C_UtlVectorEmbeddedNetworkVar< C_SpeechBubbleInfo > m_SpeechBubbles;
	uint32[4] m_nLastCountInQueue;
};

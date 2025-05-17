// MNetworkVarNames = "CSpeechBubbleInfo m_SpeechBubbles"
class CSpeechBubbleManager : public CBaseEntity
{
	// MNetworkEnable
	// MNetworkTypeAlias = "m_SpeechBubbles"
	CUtlVectorEmbeddedNetworkVar< CSpeechBubbleInfo > m_SpeechBubbles;
	uint16 m_unBubbleCount;
};

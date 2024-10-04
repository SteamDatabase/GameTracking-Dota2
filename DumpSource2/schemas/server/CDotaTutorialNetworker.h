class CDotaTutorialNetworker : public CBaseEntity
{
	int32 m_nTutorialState;
	int32 m_nTaskProgress;
	int32 m_nTaskSteps;
	int32 m_nTaskSecondsRemianing;
	int32 m_nUIState;
	int32 m_nShopState;
	Vector m_TargetLocation;
	CUtlVectorEmbeddedNetworkVar< CSpeechBubbleInfo > m_SpeechBubbles;
	int32 m_nLocationID;
	char[256] m_GuideStr;
	char[256] m_QuickBuyStr;
}

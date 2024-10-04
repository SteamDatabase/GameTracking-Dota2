class C_DotaTutorialNetworker : public C_BaseEntity
{
	int32 m_nTutorialState;
	int32 m_nTaskProgress;
	int32 m_nTaskSteps;
	int32 m_nTaskSecondsRemianing;
	int32 m_nUIState;
	int32 m_nShopState;
	Vector m_TargetLocation;
	CHandle< C_BaseEntity > m_TargetEntity;
	C_UtlVectorEmbeddedNetworkVar< C_SpeechBubbleInfo > m_SpeechBubbles;
	int32 m_nLocationID;
	char[256] m_GuideStr;
	char[256] m_QuickBuyStr;
	int32 m_nPreTutorialState;
	int32 m_nPreUIState;
	int32 m_nPreShopState;
	Vector m_vecPrevTargetLocation;
	CHandle< C_BaseEntity > m_hPrevTargetEntity;
};

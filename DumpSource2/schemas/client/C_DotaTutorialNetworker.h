// MNetworkVarNames = "int m_nTutorialState"
// MNetworkVarNames = "int m_nTaskProgress"
// MNetworkVarNames = "int m_nTaskSteps"
// MNetworkVarNames = "int m_nTaskSecondsRemianing"
// MNetworkVarNames = "int m_nUIState"
// MNetworkVarNames = "int m_nShopState"
// MNetworkVarNames = "Vector m_TargetLocation"
// MNetworkVarNames = "C_SpeechBubbleInfo m_SpeechBubbles"
// MNetworkVarNames = "int m_nLocationID"
// MNetworkVarNames = "char m_GuideStr"
// MNetworkVarNames = "char m_QuickBuyStr"
class C_DotaTutorialNetworker : public C_BaseEntity
{
	// MNetworkEnable
	int32 m_nTutorialState;
	// MNetworkEnable
	int32 m_nTaskProgress;
	// MNetworkEnable
	int32 m_nTaskSteps;
	// MNetworkEnable
	int32 m_nTaskSecondsRemianing;
	// MNetworkEnable
	int32 m_nUIState;
	// MNetworkEnable
	int32 m_nShopState;
	// MNetworkEnable
	Vector m_TargetLocation;
	CHandle< C_BaseEntity > m_TargetEntity;
	// MNetworkEnable
	// MNetworkTypeAlias = "m_SpeechBubbles"
	C_UtlVectorEmbeddedNetworkVar< C_SpeechBubbleInfo > m_SpeechBubbles;
	// MNetworkEnable
	int32 m_nLocationID;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnGuideChanged"
	char[256] m_GuideStr;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnQuickBuyChanged"
	char[256] m_QuickBuyStr;
	int32 m_nPreTutorialState;
	int32 m_nPreUIState;
	int32 m_nPreShopState;
	Vector m_vecPrevTargetLocation;
	CHandle< C_BaseEntity > m_hPrevTargetEntity;
};

// MNetworkVarNames = "int m_nTutorialState"
// MNetworkVarNames = "int m_nTaskProgress"
// MNetworkVarNames = "int m_nTaskSteps"
// MNetworkVarNames = "int m_nTaskSecondsRemianing"
// MNetworkVarNames = "int m_nUIState"
// MNetworkVarNames = "int m_nShopState"
// MNetworkVarNames = "Vector m_TargetLocation"
// MNetworkVarNames = "CSpeechBubbleInfo m_SpeechBubbles"
// MNetworkVarNames = "int m_nLocationID"
// MNetworkVarNames = "char m_GuideStr"
// MNetworkVarNames = "char m_QuickBuyStr"
class CDotaTutorialNetworker : public CBaseEntity
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
	// MNetworkEnable
	// MNetworkTypeAlias = "m_SpeechBubbles"
	CUtlVectorEmbeddedNetworkVar< CSpeechBubbleInfo > m_SpeechBubbles;
	// MNetworkEnable
	int32 m_nLocationID;
	// MNetworkEnable
	char[256] m_GuideStr;
	// MNetworkEnable
	char[256] m_QuickBuyStr;
};

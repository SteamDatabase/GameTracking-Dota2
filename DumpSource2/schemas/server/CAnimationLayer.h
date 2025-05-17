// MNetworkVarNames = "CNetworkedSequenceOperation m_op"
// MNetworkVarNames = "int m_nOrder"
// MNetworkVarNames = "AnimLoopMode_t m_nSeqLoopMode"
// MNetworkVarNames = "int m_nNewSequenceParity"
// MNetworkReplayCompatField = "m_bLooping"
class CAnimationLayer
{
	// MNetworkEnable
	// MNetworkChangeCallback = "animationLayerOpChanged"
	CNetworkedSequenceOperation m_op;
	// MNetworkEnable
	// MNetworkChangeCallback = "animationLayerOrderChanged"
	int32 m_nOrder;
	// MNetworkEnable
	// MNetworkBitCount = 10
	// MNetworkMinValue = 0.000000
	// MNetworkMaxValue = 5.000000
	// MNetworkEncodeFlags = 8
	CNetworkedQuantizedFloat m_flPlaybackRate;
	// MNetworkEnable
	AnimLoopMode_t m_nSeqLoopMode;
	// MNetworkEnable
	// MNetworkPriority = 32
	// MNetworkChangeCallback = "animationLayerCycleReset"
	int32 m_nNewSequenceParity;
	GameTime_t m_flSeqStartTime;
	float32 m_flCachedSequenceCycleRate;
	int32 m_nFlags;
	bool m_bSequenceFinished;
	GameTime_t m_flKillStartTime;
	float32 m_flKillRate;
	GameTime_t m_flLayerSuppressChangeTime;
	int32 m_nActivity;
	int32 m_nPriority;
	float32 m_flLastEventCycle;
	float32 m_flFadeInFraction;
	float32 m_flFadeOutFraction;
	bool m_bHasFadedIn;
};

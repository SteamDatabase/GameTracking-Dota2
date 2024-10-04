class CAnimationLayer
{
	CNetworkedSequenceOperation m_op;
	int32 m_nOrder;
	CNetworkedQuantizedFloat m_flPlaybackRate;
	AnimLoopMode_t m_nSeqLoopMode;
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

class CBaseAnimatingController : public CSkeletonAnimationController
{
	CNetworkedSequenceOperation m_baseLayer;
	bool m_bSequenceFinished;
	float32 m_flGroundSpeed;
	float32 m_flLastEventCycle;
	GameTime_t m_flLastEventAnimTime;
	float32 m_flSoundSyncTime;
	CNetworkedQuantizedFloat m_flPlaybackRate;
	GameTime_t m_flPrevAnimTime;
	GameTime_t m_flSeqStartTime;
	float32[24] m_flPoseParameter;
	bool m_bNetworkedAnimationInputsChanged;
	int32 m_nNewSequenceParity;
	int32 m_nResetEventsParity;
	AnimLoopMode_t m_nAnimLoopMode;
	float32 m_flCachedSequenceCycleRate;
	float32 m_flCachedGroundSpeed;
	SequenceFinishNotifyState_t m_nNotifyState;
	bool m_bHasEverDispatchedAnimEvents;
	CSequenceTransitioner2 m_SequenceTransitioner;
};
